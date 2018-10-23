defmodule ReleaseAdminWeb.PollerController do
  use ReleaseAdminWeb, :controller

  alias ReleaseAdmin.Repository.Service, as: RepositoryService
  alias ReleaseAdmin.Services.ReleasePoller
  alias ReleaseAdmin.Repo

  plug(:load_repository)

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, _params) do
    repository =
      conn.assigns[:repository]
      |> Repo.preload(:tasks)

    repository
    |> ReleasePoller.start_polling_repo()

    conn
    |> put_flash(:info, "Polling repository successfully.")
    |> redirect(to: repositories_path(conn, :show, repository))
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    repository = conn.assigns[:repository]

    repository
    |> ReleasePoller.stop_polling_repo()

    conn
    |> put_flash(:info, "Polling repository successfully stopped.")
    |> redirect(to: repositories_path(conn, :show, repository))
  end

  defp load_repository(conn, _) do
    %{"repositories_id" => id} = conn.params
    repo = RepositoryService.get!(id)
    assign(conn, :repository, repo)
  end
end
