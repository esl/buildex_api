defmodule ReleaseAdminWeb.TaskController do
  use ReleaseAdminWeb, :controller

  alias ReleaseAdmin.Repository.Service, as: RepositoryService
  alias ReleaseAdmin.Task.Service, as: TaskService
  alias ReleaseAdmin.Task
  alias Plug.Conn

  plug(:load_repository when action in [:index, :new, :create])


  @spec index(Conn.t(), map()) :: Conn.t()
  def index(conn, _params) do
    tasks =
      conn.assigns[:repository]
      |> TaskService.repo_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  @spec new(Conn.t(), map()) :: Conn.t()
  def new(conn, _params) do
    changeset = TaskService.change_task(%Task{})
    render(conn, "new.html", changeset: changeset, repo: conn.assigns[:repository])
  end

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"repositories_id" => repo_id, "task" => task_params}) do
    task_params
    |> Map.merge(%{"repository_id" => repo_id})
    |> TaskService.create_task()
    |> case do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: repositories_task_path(conn, :show, repo_id, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("new.html", changeset: changeset, repo: conn.assigns[:repository])
    end
  end

  @spec show(Conn.t(), map()) :: Conn.t()
  def show(conn, %{"id" => id}) do
    task = TaskService.get_task!(id)
    render(conn, "show.html", task: task)
  end

  @spec edit(Conn.t(), map()) :: Conn.t()
  def edit(conn, %{"id" => id}) do
    task = TaskService.get_task!(id)
    changeset = TaskService.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  @spec update(Conn.t(), map()) :: Conn.t()
  def update(conn, %{"repositories_id" => repo_id, "id" => id, "task" => task_params}) do
    task = TaskService.get_task!(id)

    case TaskService.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: repositories_task_path(conn, :show, repo_id, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("edit.html", task: task, changeset: changeset)
    end
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, %{"repositories_id" => repo_id, "id" => id}) do
    _task =
      TaskService.get_task!(id)
      |> TaskService.delete_task!()

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: repositories_path(conn, :show, repo_id))
  end

  defp load_repository(conn, _) do
    %{"repositories_id" => id} = conn.params
    repo = RepositoryService.get!(id)
    assign(conn, :repository, repo)
  end
end
