defmodule ReleaseAdmin.Services.RPC do
  alias ReleaseAdmin.RuntimeConfig

  @callback start_polling_repo(map()) :: any() | {:badrpc, any()}
  @callback stop_polling_repo(String.t()) :: any() | {:badrpc, any()}

  def start_polling_repo(repo) do
    RuntimeConfig.get_poller_domain()
    |> :rpc.call(RepoPoller.PollerSupervisor, :start_child, [repo])
  end

  def stop_polling_repo(url) do
    RuntimeConfig.get_poller_domain()
    |> :rpc.call(RepoPoller.PollerSupervisor, :stop_child, [url])
  end
end
