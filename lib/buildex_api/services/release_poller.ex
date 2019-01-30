defmodule Buildex.API.Services.ReleasePoller do
  alias Buildex.API.{Repository, Services.RPC}

  @spec start_polling_repo(Repository.t()) :: {:error, any()} | {:ok, any()}
  def start_polling_repo(repo) do
    repo_payload =
      Map.take(repo, [
        :id,
        :github_token,
        :polling_interval,
        :repository_url,
        :adapter
      ])

    case RPC.start_polling_repo(repo_payload) do
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

  @spec stop_polling_repo(Repository.t()) :: {:error, any()} | :ok
  def stop_polling_repo(%{repository_url: repository_url}) do
    case RPC.stop_polling_repo(repository_url) do
      {:badrpc, reason} ->
        {:error, reason}

      :ok ->
        :ok

      {:error, _} = error ->
        error
    end
  end
end
