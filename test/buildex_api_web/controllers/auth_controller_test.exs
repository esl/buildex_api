defmodule Buildex.API.Web.AuthControllerTest do
  use Buildex.API.Web.ConnCase
  alias Buildex.API.Web.StubsGeneration

  setup do
    {:ok, github_oauth: StubsGeneration.generate_github_auth_response()}
  end

  test "DELETE /auth/logout", %{conn: conn} do
    conn = delete(conn, "/auth/logout")
    assert html_response(conn, 302) =~ ~s(You are being <a href="/">redirected</a>)
  end

  test "GET /auth/github", %{conn: conn} do
    conn = get(conn, "/auth/github")
    assert response(conn, 302) =~ ~r".*/login/oauth/authorize\?client_id=DUMMY_CLIENT_ID.*"
  end

  test "GET /auth/github/callback", %{conn: conn, github_oauth: github_oauth} do
    conn2 = conn |> assign(:github_oauth, github_oauth) |> get("/auth/github/callback")
    assert response(conn2, 302) =~ ~s(You are being <a href="/">redirected</a>)
  end
end
