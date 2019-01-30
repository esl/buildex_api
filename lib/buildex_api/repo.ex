defmodule Buildex.API.Repo do
  use Ecto.Repo,
    otp_app: :buildex_api,
    adapter: Ecto.Adapters.Postgres

  def init(_, opts) do
    {:ok, Confex.Resolver.resolve!(opts)}
  end
end
