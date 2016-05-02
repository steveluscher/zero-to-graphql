name := "zero-to-graphql"
description := "An examples of GraphQL endpoint created using sangria and akka-http"

scalaVersion := "2.11.8"
scalacOptions ++= Seq("-deprecation", "-feature")

libraryDependencies ++= Seq(
  // GraphQL
  "org.sangria-graphql" %% "sangria" % "0.6.3",
  "org.sangria-graphql" %% "sangria-spray-json" % "0.3.1",

  // Http
  "com.typesafe.akka" %% "akka-http-experimental" % "2.4.2",
  "com.typesafe.akka" %% "akka-http-spray-json-experimental" % "2.4.2",

  // Database
  "com.typesafe.slick" %% "slick" % "3.1.1",
  "com.h2database" % "h2" % "1.4.191",
  "org.slf4j" % "slf4j-nop" % "1.7.21",

  // Testing
  "org.scalatest" %% "scalatest" % "2.2.6" % "test"
)

Revolver.settings