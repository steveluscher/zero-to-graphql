defmodule ZeroPhoenixWeb.PageController do
  use ZeroPhoenixWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
