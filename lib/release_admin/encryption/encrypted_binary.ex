defmodule ReleaseAdmin.Encryption.EncryptedBinary do
  alias ReleaseAdmin.Encryption.Vault

  use Cloak.Ecto.Binary, vault: Vault
end
