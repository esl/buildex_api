defmodule Buildex.API.Web.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> put_flash(:error, "Please login with your Github account")
        |> redirect(to: "/")
        |> halt()

      _ ->
        conn
    end
  end
end
