defmodule ReleaseAdminWeb.RepositoriesController do
  use ReleaseAdminWeb, :controller

  alias ReleaseAdmin.Repository
  alias ReleaseAdmin.Repository.Service, as: RepositoryService
  alias Plug.Conn

  @spec index(Conn.t(), any()) :: Conn.t()
  def index(conn, _params) do
    # TODO: paginate
    render(conn, "index.html", repositories: RepositoryService.all())
  end

  @spec new(Conn.t(), any()) :: Conn.t()
  def new(conn, _params) do
    changeset = Repository.changeset(%Repository{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"repository" => repository_params}) do
    %{assigns: %{current_user: current_user}} = conn

    repository_params
    |> Map.merge(%{"user_id" => current_user.id})
    |> RepositoryService.create()
    |> case do
      {:ok, repository} ->
        conn
        |> put_flash(:info, "Repository created successfully.")
        |> redirect(to: repositories_path(conn, :show, repository))

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("new.html", changeset: reason)
    end
  end

  @spec show(Conn.t(), map()) :: Conn.t()
  def show(conn, %{"id" => id}) do
    render(conn, "show.html", repo: RepositoryService.get!(id))
  end

  @spec edit(Conn.t(), map()) :: Conn.t()
  def edit(conn, %{"id" => id}) do
    repo = RepositoryService.get!(id)
    changeset = Repository.update_changeset(repo, %{})
    render(conn, "edit.html", repo: repo, changeset: changeset)
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, %{"id" => id}) do
    _repo = RepositoryService.delete!(id)

    conn
    |> put_flash(:info, "Repository deleted successfully.")
    |> redirect(to: repositories_path(conn, :index))
  end

  @spec update(Conn.t(), map()) :: Conn.t()
  def update(conn, %{"id" => id, "repository" => repository_params}) do
    id
    |> RepositoryService.update(repository_params)
    |> case do
      {:ok, repository} ->
        conn
        |> put_flash(:info, "Repository updated successfully.")
        |> redirect(to: repositories_path(conn, :show, repository))

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("edit.html", repo: reason.data, changeset: reason)
    end
  end
end
