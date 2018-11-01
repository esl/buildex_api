defmodule ReleaseAdmin.Task.ServiceTest do
  use ReleaseAdmin.DataCase
  import ReleaseAdmin.Factory

  alias ReleaseAdmin.Task.Service, as: TaskService

  describe "get_task!/1" do
    test "gets task by id" do
      task = insert(:task, runner: "make")
      db_task = TaskService.get_task!(task.id)
      assert db_task.id == task.id
      assert db_task.runner == "make"
    end

    test "raise if task not found" do
      assert_raise Ecto.NoResultsError, fn ->
        TaskService.get_task!(123_456)
      end
    end
  end

  describe "create_task/1" do
    test "successfully creates a task" do
      repo = insert(:repository)

      attrs = %{
        repository_id: repo.id,
        runner: "make",
        source: "github"
      }

      assert {:ok, task} = TaskService.create_task(attrs)
      # assert created task match attrs
      assert attrs = task
    end

    test "doesn't create a task" do
      attrs = %{
        repository_id: 123_456,
        runner: "make",
        source: "github"
      }

      assert {:error, reason} = TaskService.create_task(attrs)
      assert %{repository_id: ["does not exist"]} = errors_on(reason)
    end
  end

  describe "update_task/2" do
    test "updates already created task" do
      task = insert(:task, runner: "make")
      attrs = %{commands: ["install", "build"]}
      assert {:ok, task} = TaskService.update_task(task, attrs)
      # assert updated task match attrs
      assert attrs = task
    end

    test "can't update task's runner" do
      task = insert(:task, runner: "make")
      attrs = %{runner: "docker_build", build_file_content: "This is a test."}
      assert {:ok, task} = TaskService.update_task(task, attrs)
      # assert updated task match attrs
      assert task.runner == "make"
    end
  end

  describe "delete_task/1" do
    test "deletes task" do
      task = insert(:task)
      TaskService.delete_task!(task)

      assert_raise Ecto.NoResultsError, fn ->
        TaskService.get_task!(task.id)
      end
    end
  end

  describe "change_task/1" do
    test "creates task changeset" do
      task = insert(:task)
      assert %Ecto.Changeset{} = TaskService.change_task(task)
    end
  end

  describe "repo_tasks/1" do
    test "gets all tasks assigned to a repo" do
      repo = insert(:repository)
      insert_list(2, :task, repository: repo)
      tasks = TaskService.repo_tasks(repo)
      assert length(tasks) == 2
    end
  end
end
