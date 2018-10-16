defmodule ReleaseAdmin.Repo.Migrations.CreateRepos do
  use Ecto.Migration

  def change do
    create table(:repos) do
      add(:github_token, :string)
      add(:polling_interval, :integer, null: false)
      add(:repository_url, :string, null: false)
      add(:user_id, references(:users, on_delete: :nothing), null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:repos, [:repository_url]))
    create(index(:repos, [:user_id]))
  end
end
