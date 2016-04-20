# zero-to-graphql
Examples of GraphQL endpoints created using various languages/frameworks.

## Django

### Installation

    cd zero-django
    pip install graphene[django]
    pip install django_graphiql
    
### Seed the database

    # TODO: Write this section & add some seed data to the repo
    
### Running the example
 
    ./manage.py runserver

Visit http://localhost:8000/graphiql

## Node

### Installation

    cd zero-node
    npm install
    
### Running the example

    # Follow the instructions to start the Django server, then...
    npm start

Visit http://localhost:5000/graphiql

## Rails

### Prerequisites

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

### Installation

    cd zero-rails
    bundle

### Seed the database

    rails db:migrate
    rails db:seed

### Running the example

    rails server

Visit http://localhost:3000/graphiql
