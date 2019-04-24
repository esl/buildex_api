use Mix.Config

config :buildex_api, BuildexApiWeb.Endpoint,
  http: [port: {:system, :integer, "PORT", 8080}],
  load_from_system_env: true,
  url: [host: {:system, "HOST", "localhost"}],
  port: {:system, :integer, "PORT", 8080},
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

# Do not print debug messages in production
config :logger, level: :info

config :buildex_api,
       :db_secret_key,
       {:system, {Buildex.API.Config, :base64decode, []}, "DB_SECRET_KEY"}

config :buildex_api, Buildex.API.Repo,
  username: {:system, "POSTGRES_USERNAME"},
  password: {:system, "POSTGRES_PASSWORD"},
  database: {:system, "POSTGRES_DATABASE"},
  hostname: {:system, "POSTGRES_HOSTNAME"},
  port: {:system, :integer, "POSTGRES_PORT", 5432},
  pool_size: 10
