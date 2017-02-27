import sangria.schema._
import sangria.macros.derive._
import sangria.execution.deferred._

import scala.concurrent.ExecutionContext

object SchemaDefinition {
  case class FriendsDeferred(personId: String) extends Deferred[Seq[Person]]

  def constantComplexity[Ctx](complexity: Double) =
    Some((_: Ctx, _: Args, child: Double) ⇒ child + complexity)

  class FriendsResolver extends DeferredResolver[Repository] {
    def resolve(deferred: Vector[Deferred[Any]], ctx: Repository, queryState: Any)(implicit ec: ExecutionContext) = {
      val personIds = deferred.collect {case FriendsDeferred(personId) ⇒ personId}
      val friends = ctx.findFriends(personIds)

      deferred.map {
        case FriendsDeferred(personId) ⇒
          friends.map(_.getOrElse(personId, Seq.empty))
      }
    }
  }

  val PersonType: ObjectType[Unit, Person] = deriveObjectType(
    DocumentField("firstName", "What you yell at me"),
    DocumentField("lastName", "What you yell at me when I've been bad"),
    DocumentField("username", "Log in as this"),
    AddFields(
      Field("fullName", StringType,
        description = Some("A name sandwich"),
        resolve = c ⇒ s"${c.value.firstName} ${c.value.lastName}"),
      Field("friends", ListType(PersonType),
        description = Some("People who lent you money"),
        complexity = constantComplexity(50),
        resolve = c ⇒ FriendsDeferred(c.value.id))))

  val QueryType = ObjectType("Query", "The root of all... queries", fields[Repository, Unit](
    Field("allPeople", ListType(PersonType),
      description = Some("Everyone, everywhere"),
      complexity = constantComplexity(100),
      resolve = _.ctx.allPeople),

    Field("person", OptionType(PersonType),
      arguments = Argument("id", StringType) :: Nil,
      complexity = constantComplexity(10),
      resolve = c ⇒ c.ctx.person(c.arg[String]("id")))))

  val schema = Schema(QueryType)
}
