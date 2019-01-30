defmodule Buildex.API.TaskTest do
  use Buildex.API.DataCase
  import Buildex.API.Factory

  alias Buildex.API.Task
  alias Buildex.API.Encryption.EncryptedBinary
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

    test "validates docker credentials" do
      assert {:error, reason} =
               %Task{}
               |> Task.changeset(%{
                 repository_id: 1,
                 runner: "docker_build",
                 build_file_content: "This is a test!"
               })
               |> Repo.insert()

      assert %{docker_username: ["can't be blank"], docker_password: ["can't be blank"]}
    end

    test "validates docker attributes" do
      assert {:error, reason} =
               %Task{}
               |> Task.changeset(%{
                 repository_id: 1,
                 runner: "docker_build",
                 build_file_content: "This is a test!"
               })
               |> Repo.insert()

      assert %{docker_image_name: ["can't be blank"], docker_image_tag_tmpl: ["can't be blank"]}
    end
  end

  describe "encryption" do
    test "encrypts ssh_key" do
      repo = insert(:repository)

      task_attrs = %{
        repository_id: repo.id,
        runner: "docker_build",
        build_file_content: "This is a test!",
        ssh_key: "verylongsshkey",
        docker_username: "username",
        docker_password: "123",
        docker_image_name: "username/test",
        docker_image_tag_tmpl: "latest"
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

    test "encrypts docker password" do
      repo = insert(:repository)

      task_attrs = %{
        repository_id: repo.id,
        runner: "docker_build",
        build_file_content: "This is a test!",
        docker_username: "username",
        docker_password: "query_123",
        docker_image_name: "username/test",
        docker_image_tag_tmpl: "latest"
      }

      assert {:ok, task} =
               %Task{}
               |> Task.changeset(task_attrs)
               |> Repo.insert()

      # Use raw query to ensure docker_password is encrypted in the DB because Ecto.Types loads and decrypt
      # it automatically
      query = "select docker_password from tasks as t where t.id = $1 limit 1"
      assert {:ok, %{rows: [[result]]}} = SQL.query(Repo, query, [task.id])
      assert is_binary(result)
      assert EncryptedBinary.load(result) == {:ok, "query_123"}
    end
  end

  describe "build file content" do
    setup do
      content = "This Is A Test"
      build_file = Path.join([System.cwd!(), "test", "fixtures", "buildfile_test"])
      File.write!(build_file, content)

      on_exit(fn ->
        File.rm!(build_file)
      end)

      {:ok, path: build_file}
    end

    test "extracts build file content on insert", %{path: path} do
      repo = insert(:repository)

      attrs = %{
        repository_id: repo.id,
        runner: "docker_build",
        build_file: %{path: path}
      }

      changeset = Task.changeset(%Task{}, attrs)
      assert %{changes: %{build_file_content: "This Is A Test"}} = changeset
    end

    test "extracts build file content on update", %{path: path} do
      attrs = %{build_file: %{path: path}}
      changeset = Task.update_changeset(%Task{}, attrs)
      assert %{changes: %{build_file_content: "This Is A Test"}} = changeset
    end
  end
end
