defmodule ReleaseAdmin.RuntimeConfig do
  @callback db_secret_key() :: String.t()
end

defmodule ReleaseAdmin.LiveConfig do
  @behaviour ReleaseAdmin.RuntimeConfig
  def db_secret_key() do
    System.get_env("DB_SECRET_KEY") |> Base.decode64!()
  end
end
