defmodule ReleaseAdmin.TaskTest do
  use ReleaseAdmin.DataCase
  import ReleaseAdmin.Factory

  alias ReleaseAdmin.Task
  alias ReleaseAdmin.Encryption.EncryptedBinary
  alias Ecto.Adapters.SQL

  describe "validations" do
    test "validates repository_id is required" do
      assert {:error, reason} =
               %Task{}
               |> Task.changeset(%{})
               |> Repo.insert()

      assert %{repository_id: ["can't be blank"]} = errors_on(reason)
    end

    test "validates :runner is required" do
      assert {:error, reason} =
               %Task{}
               |> Task.changeset(%{})
               |> Repo.insert()

      assert %{runner: ["can't be blank"]} = errors_on(reason)
    end

    test "validates build_file_content is required if docker_build is the runner" do
      assert {:error, reason} =
               %Task{}
               |> Task.changeset(%{repository_id: 1, runner: "docker_build"})
               |> Repo.insert()

      assert %{build_file_content: ["can't be blank"]} = errors_on(reason)
    end

    test "validates source is required if make is the runner" do
      assert {:error, reason} =
               %Task{}
               |> Task.changeset(%{repository_id: 1, runner: "make"})
               |> Repo.insert()

      assert %{source: ["can't be blank"]} = errors_on(reason)
    end

    test "validates only make and docker_build are allowed as runners" do
      assert {:error, reason} =
               %Task{}
               |> Task.changeset(%{repository_id: 1, runner: "custom"})
               |> Repo.insert()

      assert %{runner: ["is invalid"]} == errors_on(reason)
    end
  end

  describe "encryption" do
    test "encrypts ssh_key" do
      repo = insert(:repository)

      task_attrs = %{
        repository_id: repo.id,
        runner: "docker_build",
        build_file_content: "This is a test!",
        ssh_key: "verylongsshkey"
      }

      assert {:ok, task} =
               %Task{}
               |> Task.changeset(task_attrs)
               |> Repo.insert()

      # Use raw query to ensure ssh_key is encrypted in the DB because Ecto.Types loads and decrypt
      # it automatically
      query = "select ssh_key from tasks as t where t.id = $1 limit 1"
      assert {:ok, %{rows: [[result]]}} = SQL.query(Repo, query, [task.id])
      assert is_binary(result)
      assert EncryptedBinary.load(result) == {:ok, "verylongsshkey"}
    end
  end
end
