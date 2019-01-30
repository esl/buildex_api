defmodule ReleaseAdminWeb.AuthController do
  use ReleaseAdminWeb, :controller
  require Logger

  plug(Ueberauth)

  alias Buildex.API.Auth

  # TODO: Helpers.callback_url doesn't exists change it to 404 or something
  # def request(conn, _params) do
  #   render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  # end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: u_auth}} = conn, _params) do
    with {:ok, auth} <- Auth.new(u_auth),
         {:ok, _user} <- Auth.find_or_create(auth) do
      session = Auth.new_session(auth)

      conn
      |> put_flash(:info, "Successfully authenticated.")
      |> put_session(:current_user, session)
      |> redirect(to: "/")
    else
      {:error, reason} ->
        Logger.error("auth error reason: #{inspect(reason)}")

        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
