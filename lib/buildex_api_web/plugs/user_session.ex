defmodule ReleaseAdminWeb.Plugs.UserSession do
  import Plug.Conn

  alias Buildex.API.{Repo, User}

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    case get_session(conn, :current_user) do
      nil ->
        conn

      %{username: username} ->
        user =
          username
          |> User.by_username()
          |> Repo.one!()

        assign(conn, :current_user, user)
    end
  end
end
