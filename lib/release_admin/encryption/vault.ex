defmodule ReleaseAdmin.Encryption.Vault do
  use Cloak.Vault, otp_app: :my_app

  alias ReleaseAdmin.Config

  @impl GenServer
  def init(config) do
    config =
      Keyword.put(config, :ciphers,
        default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: Config.db_secret_key()}
      )

    {:ok, config}
  end
end
