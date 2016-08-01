defmodule ZeroPhoenix.GraphQLSchema do
  alias ZeroPhoenix.QueryType

  def schema do
    %GraphQL.Schema{
      query: QueryType.type
    }
  end
end
