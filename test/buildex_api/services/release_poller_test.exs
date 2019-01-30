defmodule Buildex.API.Services.ReleasePollerTest do
  use Buildex.API.DataCase, async: true
  import Mimic
  import Buildex.API.Factory

  alias Buildex.API.Services.{ReleasePoller, RPC}

  setup :verify_on_exit!

  describe "start_polling_repo/1" do
    test "successfully started polling repository - no error" do
      repo = insert(:repository)
      pid = self()

      RPC
      |> stub(:start_polling_repo, fn payload ->
        assert %{
                 adapter: "github",
                 github_token: nil,
                 id: repo.id,
                 polling_interval: repo.polling_interval,
                 repository_url: repo.repository_url
               } == payload

        {:ok, pid}
      end)

      assert {:ok, ^pid} = ReleasePoller.start_polling_repo(repo)
    end

    test "successfully started polling repository - repository already started" do
      repo = insert(:repository)
      pid = self()

      RPC
      |> stub(:start_polling_repo, fn _ ->
        {:error, {:already_started, pid}}
      end)

      assert {:ok, ^pid} = ReleasePoller.start_polling_repo(repo)
    end

    test "error starting to poll repository" do
      repo = insert(:repository)

      RPC
      |> stub(:start_polling_repo, fn _ ->
        {:error, :kaboom}
      end)

      assert {:error, :kaboom} = ReleasePoller.start_polling_repo(repo)
    end

    test "error starting to poll repository - node down" do
      repo = insert(:repository)

      RPC
      |> stub(:start_polling_repo, fn _ ->
        {:badrpc, :nodedown}
      end)

      assert {:error, :nodedown} = ReleasePoller.start_polling_repo(repo)
    end
  end

  describe "stop_polling_repo/1" do
    test "successfully stopped polling for repository" do
      repo = insert(:repository)

      RPC
      |> stub(:stop_polling_repo, fn url ->
        assert url == repo.repository_url
        :ok
      end)

      assert :ok = ReleasePoller.stop_polling_repo(repo)
    end

    test "error stopping poller worker" do
      repo = insert(:repository)

      RPC
      |> stub(:stop_polling_repo, fn _ ->
        {:badrpc, :kaboom}
      end)

      assert {:error, :kaboom} = ReleasePoller.stop_polling_repo(repo)
    end

    test "error stopping poller worker - node down" do
      repo = insert(:repository)

      RPC
      |> stub(:stop_polling_repo, fn _ ->
        {:badrpc, :nodedown}
      end)

      assert {:error, :nodedown} = ReleasePoller.stop_polling_repo(repo)
    end
  end
end
