defmodule Buildex.API.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add(:fetch_url, :string)
      add(:ssh_key, :binary)
      add(:runner, :string)
      add(:source, :string)
      add(:env, :map, default: %{})
      add(:commands, {:array, :string}, default: [])
      add(:build_file_content, :text)
      add(:repository_id, references(:repos, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end
  end
end
