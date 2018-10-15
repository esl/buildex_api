defmodule ReleaseAdmin.Repo.Migrations.CreateRepos do
  use Ecto.Migration

  def change do
    create table(:repos) do
      add(:github_token, :string)
      add(:name, :string)
      add(:owner, :string)
      add(:polling_interval, :integer)
      add(:repository_url, :string)
      add(:user_id, references(:users, on_delete: :nothing), null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:repos, [:repository_url]))
    create(unique_index(:repos, [:owner, :name]))
    create(index(:repos, [:user_id]))
  end
end
