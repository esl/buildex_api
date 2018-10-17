{:ok, _} = Application.ensure_all_started(:ex_machina)
Mimic.copy(ReleaseAdmin.Services.Github)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(ReleaseAdmin.Repo, :manual)

