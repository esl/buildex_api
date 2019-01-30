{:ok, _} = Application.ensure_all_started(:ex_machina)
Mimic.copy(Buildex.API.Services.Github)
Mimic.copy(Buildex.API.Services.RPC)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Buildex.API.Repo, :manual)
