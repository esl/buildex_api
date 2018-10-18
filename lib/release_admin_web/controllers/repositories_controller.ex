defmodule ReleaseAdminWeb.RepositoriesController do
  use ReleaseAdminWeb, :controller

  alias ReleaseAdmin.{Repo, Repository}

  def index(conn, _params) do
    # TODO: paginate
    repositories = Repo.all(Repository)
    render(conn, "index.html", repositories: repositories)
  end

  def new(conn, _params) do
    changeset = Repository.changeset(%Repository{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"repository" => repository_params}) do
    %{assigns: %{current_user: current_user}} = conn
    repository_attrs = Map.merge(repository_params, %{"user_id" => current_user.id})

    %Repository{}
    |> Repository.changeset(repository_attrs)
    |> Repo.insert()
    |> case do
      {:ok, repository} ->
        conn
        |> put_flash(:info, "Repository created successfully.")
        |> redirect(to: repositories_path(conn, :show, repository))

      {:error, reason} ->
        render(conn, "new.html", changeset: reason)
    end
  end

  def show(conn, %{"id" => id}) do
    repo = Repo.get!(Repository, id)
    render(conn, "show.html", repo: repo)
  end

  def edit(conn, %{"id" => id}) do
    repo = Repo.get!(Repository, id)
    changeset = Repository.update_changeset(repo, %{})
    render(conn, "edit.html", repo: repo, changeset: changeset)
  end

  def delete(conn, %{"id" => id}) do
    repo = Repo.get!(Repository, id)
    {:ok, _repo} = Repo.delete(repo)

    conn
    |> put_flash(:info, "Repository deleted successfully.")
    |> redirect(to: repositories_path(conn, :index))
  end

  def update(conn, %{"id" => id, "repository" => repository_params}) do
    repo = Repo.get!(Repository, id)

    repo
    |> Repository.update_changeset(repository_params)
    |> Repo.update()
    |> case do
      {:ok, repository} ->
        conn
        |> put_flash(:info, "Repository updated successfully.")
        |> redirect(to: repositories_path(conn, :show, repository))

      {:error, reason} ->
        render(conn, "edit.html", repo: repo, changeset: reason)
    end
  end
end
