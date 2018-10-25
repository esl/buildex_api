defmodule ReleaseAdmin.Services.ReleasePoller do
  alias ReleaseAdmin.Repository

  @spec start_polling_repo(Repository.t()) :: {:error, any()} | {:ok, any()}
  def start_polling_repo(repo) do
    repo_payload = Map.take(repo, [:id, :github_token, :polling_interval, :repository_url])

    case :rpc.call(:"poller@127.0.0.1", RepoPoller.PollerSupervisor, :start_child, [
           repo_payload,
           "github"
         ]) do
      {:badrpc, reason} ->
        {:error, reason}

      {:ok, _pid} = res ->
        res

      {:error, {:already_started, pid}} ->
        {:ok, pid}

      {:error, _} = error ->
        error
    end
  end

  @spec stop_polling_repo(Repository.t()) :: {:error, any()} | {:ok, any()}
  def stop_polling_repo(repo) do
    json_repo = Poison.encode!(repo)

    case :rpc.call(:"poller@127.0.0.1", RepoPoller.PollerSupervisor, :stop_child, [json_repo]) do
      {:badrpc, reason} ->
        {:error, reason}

      {:ok, _pid} = res ->
        res

      {:error, _} = error ->
        error
    end
  end
end
