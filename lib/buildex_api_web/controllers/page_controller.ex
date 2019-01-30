defmodule ReleaseAdminWeb.PageController do
  use ReleaseAdminWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
