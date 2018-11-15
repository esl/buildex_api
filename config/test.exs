use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :release_admin, ReleaseAdminWeb.Endpoint,
  http: [port: 4001],
  server: false

config :release_admin,
  runtime_config: ReleaseAdmin.TestConfig

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :release_admin, ReleaseAdmin.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: {:system, "RELEASE_ADMIN_POSTGRES_USERNAME", "postgres"},
  password: {:system, "RELEASE_ADMIN_POSTGRES_PASSWORD", "postgres"},
  database: "release_admin_test",
  hostname: {:system, "RELEASE_ADMIN_POSTGRES_HOSTNAME", "localhost"},
  pool: Ecto.Adapters.SQL.Sandbox,
  port: {:system, "RELEASE_ADMIN_POSTGRES_PORT", "5432"}

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "DUMMY_CLIENT_ID",
  client_secret: "DUMMY_CLIENT_SECRET"
