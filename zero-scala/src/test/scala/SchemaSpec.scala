import language.postfixOps
import org.scalatest.{Matchers, WordSpec}
import sangria.ast.Document
import sangria.execution.Executor
import sangria.execution.deferred.DeferredResolver
import sangria.macros._
import sangria.marshalling.sprayJson._
import spray.json._

import scala.concurrent.Await
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration._

import SchemaDefinition.personFetcher

class SchemaSpec extends WordSpec with Matchers {
  "Schema" should {
    "return person by ID" in {
      val query =
        graphql"""
          query personWithFriends {
            person(id: "1001") {
              id
              firstName
              lastName
              fullName
              username
              email
              friends {
                id
                fullName
              }
            }
          }
        """

      executeQuery(query) should be (
        """
          {
            "data": {
              "person": {
                "id": "1001",
                "lastName": "Vasquez",
                "firstName": "Leslie",
                "fullName": "Leslie Vasquez",
                "username": "leslie.vasquez",
                "email": "eu@Duiscursusdiam.co.uk",
                "friends": [
                  {"id": "1003", "fullName": "Jena Brady"},
                  {"id": "1005", "fullName": "Alexandra Evans"}
                ]
              }
            }
          }
        """.parseJson)
    }
  }

  def executeQuery(query: Document) = {
    val repository = Repository.createDatabase()

    try {
      val futureResult = Executor.execute(SchemaDefinition.schema, query, repository,
        deferredResolver = DeferredResolver.fetchers(personFetcher))

      Await.result(futureResult, 10 seconds)
    } finally repository.close()
  }
}
