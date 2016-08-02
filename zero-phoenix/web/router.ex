defmodule ZeroPhoenix.Router do
  use ZeroPhoenix.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ZeroPhoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", ZeroPhoenix do
    pipe_through :api

    resources "/people", PersonController, except: [:new, :edit]
  end

  scope "/graphiql" do
    pipe_through :api

    # option one
    # forward "/", GraphQL.Plug, schema: {ZeroPhoenix.GraphQLSchema, :schema}

    # option two
    get  "/", GraphQL.Plug, schema: {ZeroPhoenix.GraphQLSchema, :schema}
    post "/", GraphQL.Plug, schema: {ZeroPhoenix.GraphQLSchema, :schema}
  end
end
