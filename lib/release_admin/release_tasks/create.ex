defmodule ReleaseAdmin.ReleaseTasks.Create do
  alias ReleaseAdmin.ReleaseTasks.Common

  alias ReleaseAdmin.Repo

  @spec exec() :: any()
  def exec do
    Common.setup(fn ->
      IO.puts("Running create database..")
      run()
    end)
  end

  defp run do
    app = Keyword.get(Repo.config(), :otp_app)
    IO.puts("Running migrations for #{app}")
    ReleaseAdmin.Repo.__adapter__().storage_up(Repo.config())
  end
end
