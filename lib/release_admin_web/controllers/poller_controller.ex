defmodule ReleaseAdminWeb.PollerController do
  use ReleaseAdminWeb, :controller

  require Logger

  alias ReleaseAdmin.Repository.Service, as: RepositoryService
  alias ReleaseAdmin.Services.ReleasePoller

  plug(:load_repository)

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, _params) do
    repository = conn.assigns[:repository]

    repository
    |> ReleasePoller.start_polling_repo()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Polling repository successfully.")
        |> redirect(to: repositories_path(conn, :show, repository))
      {:error, reason} ->
        Logger.error("failed to start polling #{repository.repository_url} reason #{inspect reason}")
        conn
        |> put_flash(:info, "Error starting polling job.")
        |> put_view(ReleaseAdminWeb.RepositoriesView)
        |> render("show.html", repo: repository)
    end
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    repository = conn.assigns[:repository]

    repository
    |> ReleasePoller.stop_polling_repo()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Polling repository successfully stopped.")
        |> redirect(to: repositories_path(conn, :show, repository))
      {:error, reason} ->
        Logger.error("failed to stop polling #{repository.repository_url} reason #{inspect reason}")
        conn
        |> put_flash(:info, "Error stopping poll job.")
        |> redirect(to: repositories_path(conn, :show, repository))
    end
  end

  defp load_repository(conn, _) do
    %{"repositories_id" => id} = conn.params
    repo = RepositoryService.get!(id)
    assign(conn, :repository, repo)
  end
end
