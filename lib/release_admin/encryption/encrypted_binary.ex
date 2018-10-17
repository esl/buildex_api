defmodule ReleaseAdmin.Encryption.EncryptedBinary do
  use Cloak.Fields.Binary, vault: ReleaseAdmin.Encryption.Vault
end
