defmodule Buildex.API.Services.RPC do
  alias Buildex.API.Config

  @callback start_polling_repo(map()) :: any() | {:badrpc, any()}
  @callback stop_polling_repo(String.t()) :: any() | {:badrpc, any()}

  alias Buildex.Poller.PollerSupervisor

  def start_polling_repo(repo) do
    Config.get_poller_domain()
    |> :rpc.call(PollerSupervisor, :start_child, [repo])
  end

  def stop_polling_repo(url) do
    Config.get_poller_domain()
    |> :rpc.call(PollerSupervisor, :stop_child, [url])
  end
end
