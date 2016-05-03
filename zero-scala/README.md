## Scala Example

An example Scala [GraphQL](http://facebook.github.io/graphql/) server written with [akka-http](http://doc.akka.io/docs/akka-stream-and-http-experimental/current/scala/http/) and [sangria](https://github.com/sangria-graphql/sangria).

### Prerequisites

* [Java 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
* [SBT](http://www.scala-sbt.org/download.html)

### Running the example

```bash
sbt ~reStart
```

SBT will automatically compile and restart the server on every source code change.

After server is started you can run queries interactively using [GraphiQL](https://github.com/graphql/graphiql) by opening [http://localhost:8080](http://localhost:8080) in a browser.

### Database Configuration

Example uses in-memory [H2](http://www.h2database.com/html/main.html) SQL database. Schema and example data would be re-created every time server starts.
 
If you would like to change database configuration or use different database, then please update `src/main/resources/application.conf`.

### Deferred values

Queries like this  one:

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

may result in N+1 database queries when field `friends` is fetched for every person in a list. In order to solve this problem, 
example uses [deferred values](http://sangria-graphql.org/learn/#deferred-values-and-resolver): `friends` field returns a `FriendsDeferred` instance 
which is then given to `FriendsResolver` by execution engine which is able to make batch friend queries.

### Protection against malicious queries

Due to recursive nature of the GraphQL schema, it's possible for a client to send an infinitely deep `friends` queries. As a safety measure, this example uses 
[query complexity analysis](http://sangria-graphql.org/learn/#protection-against-malicious-queries) and rejects all queries above complexity threshold (`300` by default).
