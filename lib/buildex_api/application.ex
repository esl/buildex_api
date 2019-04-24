defmodule Buildex.API.Application do
  use Application
  alias Buildex.API.Encryption.Vault
  alias Buildex.API.Repo
  alias Buildex.API.Web.Endpoint

  def start(_type, _args) do
    import Supervisor.Spec

    # https://github.com/Nebo15/confex#populating-configuration-at-start-time

    Confex.resolve_env!(:ueberauth)

    children = [
      supervisor(Repo, []),
      supervisor(Endpoint, []),
      Vault
    ]

    opts = [strategy: :one_for_one, name: Buildex.API.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
