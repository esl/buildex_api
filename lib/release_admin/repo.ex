defmodule ReleaseAdmin.Repo do
  use Ecto.Repo, otp_app: :release_admin

  alias ReleaseAdmin.RuntimeConfig

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    opts =
      opts
      |> Keyword.put(:url, RuntimeConfig.get_database_url())
      |> Keyword.put(:port, RuntimeConfig.get_database_port())

    {:ok, opts}
  end
end
