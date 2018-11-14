defmodule ReleaseAdmin.Repo do
  use Ecto.Repo, otp_app: :release_admin

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Confex.Resolver.resolve!(opts)}
  end
end
