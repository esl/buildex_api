defmodule ReleaseAdmin.Mixfile do
  use Mix.Project

  def project do
    [
      app: :release_admin,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ReleaseAdmin.Application, []},
      extra_applications: [:logger, :runtime_tools, :ueberauth, :ueberauth_github]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:cloak_ecto, "~> 1.0.0-alpha.0"},
      {:confex, "~> 3.4.0"},
      {:cowboy, "~> 2.5.0"},
      {:distillery, "~> 2.0"},
      {:ecto_sql, "~> 3.0"},
      {:ex_machina, "~> 2.2.2", only: :test},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:mimic, "~> 0.2", only: :test},
      {:phoenix, "~> 1.4.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:plug_cowboy, "~> 2.0.0"},
      {:poison, "~> 4.0.1", override: true},
      {:postgrex, "~> 0.14.1"},
      {:rexbug, ">= 1.0.0", only: :dev},
      {:tentacat, "~> 1.2.0"},
      {:ueberauth, "~> 0.4"},
      {:ueberauth_github, "~> 0.7"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
