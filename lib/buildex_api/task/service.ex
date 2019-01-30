defmodule Buildex.API.Task.Service do
  alias Buildex.API.{Repo, Repository, Task}

  @spec repo_tasks(Repository.t() | String.t()) :: list(Task.t())
  def repo_tasks(%Repository{} = repo) do
    repo = Repo.preload(repo, :tasks)
    repo.tasks
  end

  def repo_tasks(repository_url) when is_binary(repository_url) do
    Repository
    |> Repo.get_by!(repository_url: repository_url)
    |> repo_tasks()
  end

  @spec get_task!(String.t() | non_neg_integer()) :: Task.t()
  def get_task!(id), do: Repo.get!(Task, id)

  @spec create_task(map()) :: {:ok, Task.t()} | {:error, Ecto.Changeset.t()}
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_task(Task.t(), map()) :: {:ok, Task.t()} | {:error, Ecto.Changeset.t()}
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.update_changeset(attrs)
    |> Repo.update()
  end

  @spec delete_task!(Task.t()) :: Task.t() | no_return()
  def delete_task!(%Task{} = task), do: Repo.delete!(task)

  @spec change_task(Task.t()) :: Ecto.Changeset.t()
  def change_task(%Task{} = task), do: Task.changeset(task, %{})
end
