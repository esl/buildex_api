use Mix.Config


config :phoenix, :json_library, Jason

config :buildex_api,
  ecto_repos: [Buildex.API.Repo]

config :buildex_api, Buildex.API.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s2uhDrAvgw8B8Ei9YtQ4ftuxodQBPDSEIenJJR8VakidMlAIybhx5J+1o7lvpXla",
  render_errors: [view: Buildex.API.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Buildex.API.PubSub, adapter: Phoenix.PubSub.PG2]

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

config :buildex_api,
  poller_domain: {:system, "BUILDEX_POLLER_DOMAIN", "postgres"}

import_config "#{Mix.env()}.exs"
