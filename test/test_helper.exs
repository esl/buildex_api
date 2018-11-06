{:ok, _} = Application.ensure_all_started(:ex_machina)
Mimic.copy(ReleaseAdmin.Services.Github)
Mimic.copy(ReleaseAdmin.Services.RPC)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(ReleaseAdmin.Repo, :manual)
