defmodule ReleaseAdmin.ReleaseTasks.Common do
  alias ReleaseAdmin.RuntimeConfig

  @start_apps [:crypto, :logger, :ssl, :postgrex, :ecto]

  @spec setup((() -> any())) :: any()
  def setup(fun) do
    me = :release_admin

    IO.puts("Loading #{me}..")
    Application.load(me)

    IO.puts("Starting dependencies..")
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts("Starting repo..")
    RuntimeConfig.get_repo().start_link(pool_size: 1)

    fun.()

    IO.puts("Success!")
    :init.stop()
  end
end
