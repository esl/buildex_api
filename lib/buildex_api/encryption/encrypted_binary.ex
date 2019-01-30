defmodule Buildex.API.Encryption.EncryptedBinary do
  alias Buildex.API.Encryption.Vault

  use Cloak.Ecto.Binary, vault: Vault
end
