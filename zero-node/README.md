# Node example

The GraphQL schema in this example resolves data by fetching it via HTTP from the REST-ful endpoints of the Django example. This should give you an idea of how to wrap one or more existing APIs (REST, Redis, Thrift, ZeroMQ, et cetera) to expose one unified GraphQL endpoint through which your entire universe of data is accessible.

## Prerequisites

* Node >=4.2.3 (Download from https://nodejs.org/en/download/)

## Installation

    cd zero-node
    npm install

## Running the example

    # Follow the instructions to start the Node server, then...
    npm start

Visit http://localhost:5000/graphiql
