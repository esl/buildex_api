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
  client_id: {:system, "BUILDEX_GITHUB_CLIENT_ID"},
  client_secret: {:system, "BUILDEX_GITHUB_CLIENT_SECRET"}

config :buildex_api,
       :poller_domain,
       {:system, {Buildex.API.Config, :string_to_nodename, []}, "BUILDEX_POLLER_DOMAIN",
        :"buildex_poller@127.0.0.1"}

config :buildex_api,
       :db_secret_key,
       {:system, {Buildex.API.Config, :base64decode, []}, "DB_SECRET_KEY",
        <<50, 242, 77, 104, 130, 206, 248, 150, 208, 166, 156, 235, 1, 110, 81, 73, 188, 48, 107,
          86, 47, 166, 219, 164, 11, 171, 9, 81, 53, 33, 255, 7>>}

import_config "#{Mix.env()}.exs"
