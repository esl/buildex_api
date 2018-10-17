defmodule ReleaseAdminWeb.Plugs.UserSession do
  import Plug.Conn

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end
end
