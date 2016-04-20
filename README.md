# zero-to-graphql
Examples of GraphQL endpoints created using various languages/frameworks.

## Django

### Prerequisites

* Xcode Command Line Tools

    ```
    # Download from (https://developer.apple.com/xcode/download/)
    xcode-select --install
    ```

* Python >=3.5.0

    ```
    # Install pyenv with Homebrew (https://github.com/yyuu/pyenv#homebrew-on-mac-os-x)
    brew install pyenv
    # Install Python 3 with pyenv
    cd zero-django
    pyenv install
    ```

### Installation

    cd zero-django
    pip install -r requirements.txt

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
