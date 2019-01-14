defmodule ReleaseAdmin.Repo do
  use Ecto.Repo,
    otp_app: :release_admin,
    adapter: Ecto.Adapters.Postgres

  def init(_, opts) do
    {:ok, Confex.Resolver.resolve!(opts)}
  end
end
