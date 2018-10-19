defmodule ReleaseAdmin.RuntimeConfig do
  @callback _db_secret_key() :: String.t()

  def db_secret_key do
    mod = Application.get_env(:release_admin, :runtime_config)
    mod._db_secret_key()
  end
end

defmodule ReleaseAdmin.LiveConfig do
  @behaviour ReleaseAdmin.RuntimeConfig
  def _db_secret_key() do
    System.get_env("DB_SECRET_KEY") |> Base.decode64!()
  end
end
