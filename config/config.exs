# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :release_admin,
  ecto_repos: [ReleaseAdmin.Repo]

# Configures the endpoint
config :release_admin, ReleaseAdminWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s2uhDrAvgw8B8Ei9YtQ4ftuxodQBPDSEIenJJR8VakidMlAIybhx5J+1o7lvpXla",
  render_errors: [view: ReleaseAdminWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ReleaseAdmin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
