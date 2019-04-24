defmodule Buildex.API.Web.PageController do
  use Buildex.API.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
