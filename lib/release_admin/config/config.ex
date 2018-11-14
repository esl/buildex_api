defmodule ReleaseAdmin.RuntimeConfig do
  alias ReleaseAdmin.Services.RPC

  @callback _db_secret_key() :: String.t()

  def db_secret_key do
    mod = Application.get_env(:release_admin, :runtime_config)
    mod._db_secret_key()
  end

  def get_poller_domain do
    Application.get_env(:release_admin, :poller_domain, :"poller@127.0.0.1")
  end

  def get_rpc_impl do
    Application.get_env(:release_admin, :rpc_impl, RPC)
  end

  def get_database_port do
    System.get_env("RELEASE_ADMIN_POSTGRES_PORT") || "5432"
  end

  def get_database_url do
    System.get_env("DATABASE_URL")
  end
end

defmodule ReleaseAdmin.LiveConfig do
  @behaviour ReleaseAdmin.RuntimeConfig
  def _db_secret_key() do
    System.get_env("DB_SECRET_KEY") |> Base.decode64!()
  end
end
