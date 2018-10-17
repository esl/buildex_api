defmodule ReleaseAdmin.Config do
  @spec db_secret_key() :: String.t()
  def db_secret_key() do
    "DB_SECRET_KEY"
    |> System.get_env()
    |> Base.decode64!()
  end
end
