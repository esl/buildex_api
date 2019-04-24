defmodule Buildex.API.Web.PollerControllerTest do
  use Buildex.API.Web.ConnCase
  import Mimic
  import Buildex.API.Factory
  import ExUnit.CaptureLog

  alias Buildex.API.Auth.Session
  alias Buildex.API.Services.RPC

  setup :verify_on_exit!

  setup %{conn: conn} do
    user = insert(:user)
    repo = insert(:repository, user: user)
    session = Session.new(user.username, user.email)
    # https://paulhoffer.com/2018/03/22/easy-session-testing-in-phoenix-and-plug.html
    conn = Plug.Test.init_test_session(conn, current_user: session)
    {:ok, conn: conn, user: user, repo: repo}
  end

  describe "create" do
    test "start polling repository successfully", %{conn: conn, repo: repo} do
      RPC
      |> stub(:start_polling_repo, fn _ ->
        {:ok, ""}
      end)

      conn = post(conn, repositories_poller_path(conn, :create, repo))
      redirected_path = redirected_to(conn)
      assert redirected_path == repositories_path(conn, :show, repo)

      response =
        conn
        |> get(redirected_path)
        |> html_response(200)

      assert response =~ "Polling repository successfully."
    end

    test "error starting poller - nodedown", %{conn: conn, repo: repo} do
      RPC
      |> stub(:start_polling_repo, fn _ ->
        {:error, :nodedown}
      end)

      log =
        capture_log(fn ->
          conn = post(conn, repositories_poller_path(conn, :create, repo))
          redirected_path = redirected_to(conn)
          assert redirected_path == repositories_path(conn, :show, repo)

          response =
            conn
            |> get(redirected_path)
            |> html_response(200)

          assert response =~ "Error starting polling job."
        end)

      assert log =~ "failed to start polling #{repo.repository_url} reason :nodedown"
    end
  end

  describe "delete" do
    test "repository poller successfully stopped", %{conn: conn, repo: repo} do
      RPC
      |> stub(:stop_polling_repo, fn _ ->
        :ok
      end)

      conn = delete(conn, repositories_poller_path(conn, :delete, repo))
      redirected_path = redirected_to(conn)
      assert redirected_path == repositories_path(conn, :show, repo)

      response =
        conn
        |> get(redirected_path)
        |> html_response(200)

      assert response =~ "Polling repository successfully stopped."
    end

    test "error stopping poller - nodedown", %{conn: conn, repo: repo} do
      RPC
      |> stub(:stop_polling_repo, fn _ ->
        {:error, :nodedown}
      end)

      log =
        capture_log(fn ->
          conn = delete(conn, repositories_poller_path(conn, :delete, repo))
          redirected_path = redirected_to(conn)
          assert redirected_path == repositories_path(conn, :show, repo)

          response =
            conn
            |> get(redirected_path)
            |> html_response(200)

          assert response =~ "Error stopping poll job."
        end)

      assert log =~ "failed to stop polling #{repo.repository_url} reason :nodedown"
    end
  end
end
