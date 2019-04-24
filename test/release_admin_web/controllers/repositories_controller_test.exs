defmodule BuildexApiWeb.RepositoriesControllerTest do
  use BuildexApiWeb.ConnCase
  import Buildex.API.Factory

  alias Buildex.API.Auth.Session
  alias Buildex.API.Repository.Service, as: RepositoryService

  setup %{conn: conn} do
    user = insert(:user)
    session = Session.new(user.username, user.email)
    # https://paulhoffer.com/2018/03/22/easy-session-testing-in-phoenix-and-plug.html
    conn = Plug.Test.init_test_session(conn, current_user: session)
    {:ok, conn: conn, user: user}
  end

  describe "index" do
    test "gets all repos", %{conn: conn, user: user} do
      [repo1, repo2] = insert_list(2, :repository, user: user)

      response =
        conn
        |> get(repositories_path(conn, :index))
        |> html_response(200)

      assert response =~ repo1.repository_url
      assert response =~ repo2.repository_url
    end
  end

  describe "create" do
    test "creates a repository", %{conn: conn} do
      params = params_for(:repository)

      conn = post(conn, repositories_path(conn, :create), %{"repository" => params})
      redirected_path = redirected_to(conn)

      assert %{id: repo_id} = redirected_params(conn)
      assert redirected_path == repositories_path(conn, :show, repo_id)

      response =
        conn
        |> get(redirected_path)
        |> html_response(200)

      assert response =~ repo_id
      assert response =~ params.repository_url
      assert response =~ "Repository created successfully."
    end

    test "couldn't create a repository", %{conn: conn} do
      conn
      |> post(repositories_path(conn, :create), %{"repository" => %{}})
      |> html_response(422)
    end
  end

  describe "show" do
    test "dislplays repository page", %{conn: conn} do
      %{id: repo_id, repository_url: repository_url} = insert(:repository)

      response =
        conn
        |> get(repositories_path(conn, :show, repo_id))
        |> html_response(200)

      assert response =~ to_string(repo_id)
      assert response =~ repository_url
    end
  end

  describe "update" do
    test "updates repository attributes", %{conn: conn} do
      %{id: repo_id} = insert(:repository)
      params = %{polling_interval: 3600}

      conn = patch(conn, repositories_path(conn, :update, repo_id), %{"repository" => params})
      redirected_path = redirected_to(conn)
      assert redirected_path == repositories_path(conn, :show, repo_id)

      response =
        conn
        |> get(redirected_path)
        |> html_response(200)

      assert response =~ to_string(repo_id)
      assert response =~ to_string(params.polling_interval)
      assert response =~ "Repository updated successfully."
    end

    test "doesn't update repository url", %{conn: conn} do
      %{id: repo_id, repository_url: repository_url} = insert(:repository)
      params = %{repository_url: "http://localhost:4000/new_url"}

      conn = patch(conn, repositories_path(conn, :update, repo_id), %{"repository" => params})
      redirected_path = redirected_to(conn)
      assert redirected_path == repositories_path(conn, :show, repo_id)

      response =
        conn
        |> get(redirected_path)
        |> html_response(200)

      assert response =~ to_string(repo_id)
      assert response =~ repository_url
      assert response =~ "Repository updated successfully."
    end

    test "couldn't update repository", %{conn: conn} do
      %{id: repo_id} = insert(:repository)
      params = %{polling_interval: ""}

      conn
      |> patch(repositories_path(conn, :update, repo_id), %{"repository" => params})
      |> html_response(422)
    end
  end

  describe "delete" do
    test "fully deletes a repo", %{conn: conn} do
      %{id: repo_id} = insert(:repository)
      conn = delete(conn, repositories_path(conn, :delete, repo_id))
      redirected_path = redirected_to(conn)
      assert redirected_to(conn) == repositories_path(conn, :index)

      response =
        conn
        |> get(redirected_path)
        |> html_response(200)

      assert response =~ "Repository deleted successfully."

      assert_raise Ecto.NoResultsError, fn ->
        RepositoryService.get!(repo_id)
      end
    end
  end
end
