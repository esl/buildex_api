defmodule Buildex.API.ReleaseTasks.Create do
  alias Buildex.API.ReleaseTasks.Common

  alias Buildex.API.Repo

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
    Buildex.API.Repo.__adapter__().storage_up(Repo.config())
  end
end
