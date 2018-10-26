defmodule ReleaseAdmin.Repo.Migrations.AddAdapterToRepos do
  use Ecto.Migration

  def change do
    alter table(:repos) do
      add(:adapter, :string, null: false)
    end
  end
end
