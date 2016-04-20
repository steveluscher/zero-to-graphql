# Rails example

## Prerequisites

* Ruby >=2.3.0

    ```
    # Install with RVM (https://rvm.io/rvm/install)
    \curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3
    ```

* Bundler >=1.11.2

    ```
    # Install with `gem install`
    gem install bundler
    ```

## Installation

    cd zero-rails
    bundle

## Seed the database

    rails db:migrate
    rails db:seed

## Running the example

    rails server

Visit http://localhost:3000/graphiql
