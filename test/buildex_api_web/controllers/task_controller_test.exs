defmodule Buildex.API.Web.TaskControllerTest do
  use Buildex.API.Web.ConnCase
  import Buildex.API.Factory

  alias Buildex.API.Auth.Session
  alias Buildex.API.{Repo, Task}

  setup %{conn: conn} do
    user = insert(:user)
    repo = insert(:repository, user: user)
    session = Session.new(user.username, user.email)
    # https://paulhoffer.com/2018/03/22/easy-session-testing-in-phoenix-and-plug.html
    conn = Plug.Test.init_test_session(conn, current_user: session)
    {:ok, conn: conn, user: user, repo: repo}
  end

  describe "index" do
    test "lists all repository tasks", %{conn: conn, repo: repo} do
      [task1, task2] =
        insert_list(2, :task,
          repository: repo,
          docker_username: "username",
          docker_password: "123"
        )

      conn = get(conn, repositories_task_path(conn, :index, repo))
      assert html_response(conn, 200) =~ to_string(task1.id)
      assert html_response(conn, 200) =~ to_string(task2.id)
    end
  end

  describe "new" do
    test "renders form", %{conn: conn, repo: repo} do
      conn = get(conn, repositories_task_path(conn, :new, repo))
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "create" do
    test "redirects to show when data is valid", %{conn: conn, repo: repo} do
      attrs = %{runner: "make", source: "github"}
      conn = post(conn, repositories_task_path(conn, :create, repo), task: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == repositories_task_path(conn, :show, repo, id)

      conn = get(conn, repositories_task_path(conn, :show, repo, id))
      assert html_response(conn, 200) =~ "Task created successfully."
    end

    test "uploads build file", %{conn: conn, repo: repo} do
      content = "This Is A Test"
      build_file = Path.join([File.cwd!(), "test", "fixtures", "buildfile_test"])
      File.write!(build_file, content)

      on_exit(fn ->
        File.rm!(build_file)
      end)

      upload = %Plug.Upload{path: build_file, filename: "buildfile_test"}

      attrs = %{
        runner: "docker_build",
        build_file: upload,
        docker_username: "username",
        docker_password: "123",
        docker_image_name: "username/test",
        docker_image_tag_tmpl: "latest"
      }

      conn = post(conn, repositories_task_path(conn, :create, repo), task: attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == repositories_task_path(conn, :show, repo, id)

      conn = get(conn, repositories_task_path(conn, :show, repo, id))
      response = html_response(conn, 200)
      assert response =~ "Task created successfully."
      assert response =~ "This Is A Test"
    end

    test "renders errors when data is invalid", %{conn: conn, repo: repo} do
      conn = post(conn, repositories_task_path(conn, :create, repo), task: %{})
      assert html_response(conn, 422) =~ "New Task"
    end
  end

  describe "edit task" do
    test "renders form for editing chosen task", %{conn: conn, repo: repo} do
      task = insert(:task, repository: repo)
      conn = get(conn, repositories_task_path(conn, :edit, repo, task))
      assert html_response(conn, 200) =~ "Edit Task"
    end
  end

  describe "update task" do
    test "redirects when data is valid", %{conn: conn, repo: repo} do
      task = insert(:task, repository: repo)
      attrs = %{fetch_url: "https://github.com"}
      conn = put(conn, repositories_task_path(conn, :update, repo, task), task: attrs)
      assert redirected_to(conn) == repositories_task_path(conn, :show, repo, task)

      conn = get(conn, repositories_task_path(conn, :show, repo, task))
      assert html_response(conn, 200) =~ "Task updated successfully."
    end
  end

  describe "try to update password credential" do
    test "do not allow change the password to an empty value", %{conn: conn, repo: repo} do
      task = insert(:task, repository: repo)
      attrs = %{docker_password: ""}
      conn = put(conn, repositories_task_path(conn, :update, repo, task), task: attrs)
      assert redirected_to(conn) == repositories_task_path(conn, :show, repo, task)
      assert task.docker_password == Repo.get!(Task, task.id).docker_password
    end
  end

  describe "delete task" do
    test "deletes chosen task", %{conn: conn, repo: repo} do
      task = insert(:task, repository: repo)
      conn = delete(conn, repositories_task_path(conn, :delete, repo, task))
      assert redirected_to(conn) == repositories_path(conn, :show, repo)

      assert_error_sent(404, fn ->
        get(conn, repositories_task_path(conn, :show, repo, task))
      end)
    end
  end
end
