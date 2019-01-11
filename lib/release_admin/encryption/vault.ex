defmodule ReleaseAdmin.Encryption.Vault do
  use Cloak.Vault, otp_app: :release_admin

  @impl GenServer
  def init(config) do
    secret_key = ReleaseAdmin.Config.db_secret_key()

    config =
      Keyword.put(config, :ciphers,
        default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: secret_key}
      )

    {:ok, config}
  end
end
