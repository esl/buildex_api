use Mix.Config

config :release_admin, ReleaseAdminWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :release_admin, ReleaseAdminWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/release_admin_web/views/.*(ex)$},
      ~r{lib/release_admin_web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :release_admin,
       :db_secret_key,
       {:system, :base64, "DB_SECRET_KEY",
        <<50, 242, 77, 104, 130, 206, 248, 150, 208, 166, 156, 235, 1, 110, 81, 73, 188, 48, 107,
          86, 47, 166, 219, 164, 11, 171, 9, 81, 53, 33, 255, 7>>}

# "MvJNaILO+JbQppzrAW5RSbwwa1YvptukC6sJUTUh/wc="

config :release_admin, ReleaseAdmin.Repo,
  username: {:system, "POSTGRES_USERNAME", "postgres"},
  password: {:system, "POSTGRES_PASSWORD", "postgres"},
  database: "release_admin_dev",
  hostname: {:system, "POSTGRES_HOSTNAME", "localhost"},
  pool_size: 10
