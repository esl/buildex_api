defmodule BuildexApi.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add(:name, :string, null: false)
      add(:node_id, :string)
      add(:commit_sha, :string, null: false)
      add(:commit_url, :string, null: false)
      add(:zipball_url, :string)
      add(:tarball_url, :string)
      add(:repository_id, references(:repos, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:tags, [:repository_id, :name]))
  end
end
