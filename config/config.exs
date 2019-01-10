use Mix.Config

config :release_admin,
  ecto_repos: [ReleaseAdmin.Repo]

config :release_admin, ReleaseAdminWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s2uhDrAvgw8B8Ei9YtQ4ftuxodQBPDSEIenJJR8VakidMlAIybhx5J+1o7lvpXla",
  render_errors: [view: ReleaseAdminWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ReleaseAdmin.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :ueberauth, Ueberauth,
  providers: [
    github:
      {Ueberauth.Strategy.Github, [default_scope: "read:user, user:email, read:org, repo:status"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: {:system, "GITHUB_CLIENT_ID"},
  client_secret: {:system, "GITHUB_CLIENT_SECRET"}

import_config "#{Mix.env()}.exs"
