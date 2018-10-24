defmodule ReleaseAdmin.Services.ReleasePoller do
  alias ReleaseAdmin.Repository

  @spec start_polling_repo(Repository.t()) :: {:error, any()} | {:ok, any()}
  def start_polling_repo(repo) do
    json_repo = Poison.encode!(repo)

    case :rpc.call(:"poller@127.0.0.1", RepoPoller.PollerSupervisor, :start_child, [
           json_repo,
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

  def stop_polling_repo(repo) do
  end
end
