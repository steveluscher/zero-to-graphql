import SchemaDefinition.FriendsResolver
import akka.actor.ActorSystem
import akka.http.scaladsl.Http
import akka.http.scaladsl.server.Directives._
import akka.http.scaladsl.model.StatusCodes._
import akka.http.scaladsl.server._
import akka.stream.ActorMaterializer

import akka.http.scaladsl.marshallers.sprayjson.SprayJsonSupport._

import sangria.parser.QueryParser
import sangria.execution._
import sangria.marshalling.sprayJson._
import sangria.schema.Schema

import spray.json._

import scala.util.{Success, Failure}

object Server extends App {
  implicit val system = ActorSystem("sangria-server")
  implicit val materializer = ActorMaterializer()

  import system.dispatcher

  val repository = Repository.createDatabase()

  case object TooComplexQuery extends Exception

  val rejectComplexQueries = QueryReducer.rejectComplexQueries(300,
    (_: Double, _: Repository) ⇒ TooComplexQuery)

  val exceptionHandler: Executor.ExceptionHandler = {
    case (_, TooComplexQuery) ⇒ HandledException("Too complex query. Please reduce the field selection.")
  }

  def executeGraphQLQuery(schema: Schema[Repository, Unit], queryInfo: JsValue) = {
    val JsObject(fields) = queryInfo
    val JsString(query) = fields("query")
    val operation = fields.get("operationName") collect {
      case JsString(op) ⇒ op
    }

    val vars = fields.get("variables") match {
      case Some(obj: JsObject) ⇒ obj
      case Some(JsString(s)) if s.trim.nonEmpty ⇒ s.parseJson
      case _ ⇒ JsObject.empty
    }

    QueryParser.parse(query) match {

      // query parsed successfully, time to execute it!
      case Success(queryDocument) ⇒
        complete(Executor.execute(schema, queryDocument, repository,
            variables = vars,
            operationName = operation,
            queryReducers = rejectComplexQueries :: Nil,
            exceptionHandler = exceptionHandler,
            deferredResolver = new FriendsResolver)
          .map(OK → _)
          .recover {
            case error: QueryAnalysisError ⇒ BadRequest → error.resolveError
            case error: ErrorWithResolver ⇒ InternalServerError → error.resolveError
          })

      // can't parse GraphQL query, return error
      case Failure(error) ⇒
        complete(BadRequest, JsObject("error" → JsString(error.getMessage)))
    }
  }

  val route: Route =
    (post & path("graphql")) {
      entity(as[JsValue]) { requestJson ⇒
        executeGraphQLQuery(SchemaDefinition.schema, requestJson)
      }
    } ~
    get {
      getFromResource("graphiql.html")
    }

  Http().bindAndHandle(route, "0.0.0.0", 8080)
}
