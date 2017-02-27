name := "zero-to-graphql"
description := "An examples of GraphQL endpoint created using sangria and akka-http"

scalaVersion := "2.12.0"
scalacOptions ++= Seq("-deprecation", "-feature")

libraryDependencies ++= Seq(
  // GraphQL
  "org.sangria-graphql" %% "sangria" % "1.0.0",
  "org.sangria-graphql" %% "sangria-spray-json" % "1.0.0",

  // Http
  "com.typesafe.akka" %% "akka-http" % "10.0.4",
  "com.typesafe.akka" %% "akka-http-spray-json" % "10.0.4",

  // Database
  "com.typesafe.slick" %% "slick" % "3.2.0",
  "com.h2database" % "h2" % "1.4.193",
  "org.slf4j" % "slf4j-nop" % "1.7.21",

  // Testing
  "org.scalatest" %% "scalatest" % "3.0.1" % Test
)

Revolver.settings