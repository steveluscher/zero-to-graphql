import sangria.schema._
import sangria.macros.derive._
import sangria.execution.deferred._

object SchemaDefinition {
  def constantComplexity[Ctx](complexity: Double) =
    Some((_: Ctx, _: Args, child: Double) ⇒ child + complexity)

  val friend = Relation[Person, (Seq[String], Person), String]("friend", _._1, _._2)

  val personFetcher = Fetcher.relCaching(
    (repo: Repository, ids: Seq[String]) ⇒ repo.people(ids),
    (repo: Repository, ids: RelationIds[Person]) ⇒ repo.findFriends(ids(friend))
  )(HasId(_.id))

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
        resolve = c ⇒ personFetcher.deferRelSeq(friend, c.value.id))))

  val QueryType = ObjectType("Query", "The root of all... queries", fields[Repository, Unit](
    Field("allPeople", ListType(PersonType),
      description = Some("Everyone, everywhere"),
      complexity = constantComplexity(100),
      resolve = _.ctx.allPeople),

    Field("person", OptionType(PersonType),
      arguments = Argument("id", StringType) :: Nil,
      complexity = constantComplexity(10),
      resolve = c ⇒ personFetcher.deferOpt(c.arg[String]("id")))))

  val schema = Schema(QueryType)
}
