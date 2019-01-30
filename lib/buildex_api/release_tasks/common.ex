defmodule Buildex.API.ReleaseTasks.Common do
  alias Buildex.API.Repo

  @start_apps [:crypto, :logger, :ssl, :postgrex, :ecto_sql]

  @spec setup((() -> any())) :: any()
  def setup(fun) do
    me = :buildex_api

    IO.puts("Loading #{me}..")
    Application.load(me)

    IO.puts("Starting dependencies..")
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts("Starting repo..")
    Repo.start_link(pool_size: 2)

    fun.()

    IO.puts("Success!")
    :init.stop()
  end
end
