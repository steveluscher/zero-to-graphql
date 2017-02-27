import language.postfixOps

import scala.concurrent.Await
import scala.concurrent.duration._
import slick.jdbc.H2Profile.api._
import scala.concurrent.ExecutionContext.Implicits.global

case class Person(id: String, firstName: String, lastName: String, username: String, email: String)
case class Friend(personId: String, friendId: String)

class Repository(db: Database) {
  import Repository._

  def allPeople =
    db.run(People.result)

  def person(id: String) =
    db.run(People.filter(_.id === id).result.headOption)

  def findFriends(personIds: Seq[String]) =
    db.run(friendsQuery(personIds).result).map(result ⇒
      result.groupBy(_._1.personId).mapValues(_.map(_._2)))

  def close() = db.close()
}

object Repository {
  class PersonTable(tag: Tag) extends Table[Person](tag, "PEOPLE") {
    def id = column[String]("PERSON_ID", O.PrimaryKey)
    def firstName = column[String]("FIRST_NAME")
    def lastName = column[String]("LAST_NAME")
    def username = column[String]("USERNAME")
    def email = column[String]("EMAIL")

    def * = (id, firstName, lastName, username, email) <> ((Person.apply _).tupled, Person.unapply)
  }

  val People = TableQuery[PersonTable]

  class FriendTable(tag: Tag) extends Table[Friend](tag, "FRIENDS") {
    def personId = column[String]("PERSON_ID")
    def friendId = column[String]("FRIEND_ID")

    def person = foreignKey("PERSON_FK", personId, People)(_.id)
    def friend = foreignKey("FRIEND_FK", friendId, People)(_.id)
    def idx = index("UNIQUE_IDX", (personId, friendId), unique = true)

    def * = (personId, friendId) <> ((Friend.apply _).tupled, Friend.unapply)
  }

  val Friends = TableQuery[FriendTable]

  val InitialDatabaseSetup = DBIO.seq(
    (People.schema ++ Friends.schema).create,

    People ++= Seq(
      Person("1000", "Brianna", "Stephenson", "brianna.stephenson", "justo.eu@Lorem.edu"),
      Person("1001", "Leslie", "Vasquez", "leslie.vasquez", "eu@Duiscursusdiam.co.uk"),
      Person("1002", "Garrison", "Douglas", "garrison.douglas", "rutrum@tristiquesenectuset.com"),
      Person("1003", "Jena", "Brady", "jena.brady", "blandit.Nam@Inat.ca"),
      Person("1004", "Evan", "Cain", "evan.cain", "sem.ut.dolor@etarcu.co.uk"),
      Person("1005", "Alexandra", "Evans", "alexandra.evans", "nisi.Mauris@Fuscealiquet.co.uk"),
      Person("1006", "Nigel", "May", "nigel.may", "semper.et@metussitamet.ca")),

    Friends ++= Seq(
      Friend("1000", "1001"),
      Friend("1000", "1004"),
      Friend("1000", "1006"),
      Friend("1001", "1003"),
      Friend("1001", "1005"),
      Friend("1002", "1004"),
      Friend("1003", "1005"),
      Friend("1003", "1006"),
      Friend("1005", "1001"),
      Friend("1005", "1004")))

  def createDatabase() = {
    val db = Database.forConfig("memoryDb")

    Await.result(db.run(InitialDatabaseSetup), 10 seconds)

    new Repository(db)
  }

  private def friendsQuery(personIds: Seq[String]) =
    Friends.filter(_.personId inSet personIds)
      .join(People).on(_.friendId === _.id)
}
