defmodule ZeroPhoenix.PageController do
  use ZeroPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
