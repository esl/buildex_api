use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :release_admin, ReleaseAdminWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :release_admin, ReleaseAdmin.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "release_admin_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "DUMMY_CLIENT_ID",
  client_secret: "DUMMY_CLIENT_SECRET"
