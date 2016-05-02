## Scala Example

An example Scala [GraphQL](http://facebook.github.io/graphql/) server written with [akka-http](http://doc.akka.io/docs/akka-stream-and-http-experimental/current/scala/http/) and [sangria](https://github.com/sangria-graphql/sangria).

### Prerequisites

* [Java 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
* [SBT](http://www.scala-sbt.org/download.html)

### Running the example

```bash
sbt ~reStart
```

SBT will automatically compile and restart the server whenever the source code changes.

After the server is started you can run queries interactively using [GraphiQL](https://github.com/graphql/graphiql) by opening [http://localhost:8080](http://localhost:8080) in a browser.

### Database Configuration

This example uses an in-memory [H2](http://www.h2database.com/html/main.html) SQL database. The schema and example data will be re-created every time server starts.

If you would like to change the database configuration or use a different database, then please update `src/main/resources/application.conf`.

### Deferred values

Queries like this one:

```js
query AllPeopleWithFriends {
  allPeople {
    fullName
    friends {
      firstName
      lastName
    }
  }
}
```

…may result in N+1 database queries since the `friends` field is fetched for every person in a list. In order to solve this problem, the example uses [deferred values](http://sangria-graphql.org/learn/#deferred-values-and-resolver): the `friends` field returns a `FriendsDeferred` instance which is then given to `FriendsResolver` by the execution engine, enabling it to batch friend queries.

### Protection against malicious queries

Due to the recursive nature of the GraphQL schema, it's possible for a client to send infinitely deep `friends` queries. As a safety measure, this example uses [query complexity analysis](http://sangria-graphql.org/learn/#protection-against-malicious-queries) and rejects all queries above a complexity threshold (`300` by default).
