use Mix.Config

config :release_admin, ReleaseAdminWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :release_admin, ReleaseAdmin.Repo,
  username: "postgres",
  password: "postgres",
  database: "release_admin_test",
  hostname: {:system, "POSTGRES_HOSTNAME", "localhost"},
  port: {:system, :integer, "POSTGRES_PORT", 5432},
  pool: Ecto.Adapters.SQL.Sandbox

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "DUMMY_CLIENT_ID",
  client_secret: "DUMMY_CLIENT_SECRET"

config :release_admin,
       :db_secret_key,
       {:system, :base64, "DB_SECRET_KEY",
        <<50, 242, 77, 104, 130, 206, 248, 150, 208, 166, 156, 235, 1, 110, 81, 73, 188, 48, 107,
          86, 47, 166, 219, 164, 11, 171, 9, 81, 53, 33, 255, 7>>}
