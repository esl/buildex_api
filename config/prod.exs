use Mix.Config

config :release_admin, ReleaseAdminWeb.Endpoint,
  http: [port: {:system, :integer, "PORT"}],
  load_from_system_env: true,
  url: [host: "localhost", port: {:system, :integer, "PORT"}],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :release_admin, ReleaseAdmin.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: {:system, "RELEASE_ADMIN_POSTGRES_USERNAME"},
  password: {:system, "RELEASE_ADMIN_POSTGRES_PASSWORD"},
  database: "release_admin",
  hostname: {:system, "RELEASE_ADMIN_POSTGRES_HOSTNAME"},
  pool_size: 10
