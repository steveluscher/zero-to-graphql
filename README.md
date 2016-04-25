# zero-to-graphql

In this repository, you will find examples of GraphQL endpoints created using various languages atop different frameworks. The goal is to demonstrate how you might go about creating a GraphQL endpoint atop your *existing* infrastructure, whatever that may be, without having to rewrite your data model.

## Watch the original presentation

[![Zero to GraphQL in 30 Minutes &ndash; video](https://i.ytimg.com/vi/UBGzsb2UkeY/0.jpg)](https://youtu.be/UBGzsb2UkeY)

## The examples' data model

Every example in this repository exposes a `Person` data model using an API considered idiomatic for the framework in question (eg. ActiveRecord for Rails). The type definition of the `Person` model looks like this:

    type Person {
      id: String!
      first_name: String!
      last_name: String!
      username: String!
      email: String!
      friends: [Person]
    }

## Running the examples

Each example features its own `README.md` file to help you get up and running.

## Contributing

See a language or framework for which there is no example? Feel free to send us a pull request! Expose the data model outlined above using whatever API you like, be sure to provide some seed data, and write a `README` that outlines all of the steps needed to get up and running with an instance of GraphiQL that you can use to issue queries to your new GraphQL endpoint.
