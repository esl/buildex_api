defmodule ReleaseAdmin.ReleaseTasks.Migrate do
  alias ReleaseAdmin.ReleaseTasks.Common

  alias ReleaseAdmin.Repo

  @spec exec() :: any()
  def exec do
    Common.setup(fn ->
      IO.puts("Runing migrations..")
      migrate()
    end)
  end

  defp migrate do
    app = Keyword.get(Repo.config(), :otp_app)
    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(Repo, migrations_path(Repo), :up, all: true)
  end

  defp migrations_path(repo), do: priv_path_for(repo, "migrations")

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir =
      app
      |> :code.priv_dir()
      |> to_string()

    Path.join([priv_dir, repo_underscore, filename])
  end
end
