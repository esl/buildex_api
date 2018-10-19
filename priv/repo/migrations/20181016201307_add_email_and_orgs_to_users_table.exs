defmodule ReleaseAdmin.Repo.Migrations.AddEmailAndOrgsToUsersTable do
  use Ecto.Migration

  def up do
    alter table(:users) do
      remove(:avatar)
      add(:email, :string, null: false)
      add(:orgs, {:array, :string}, null: false, default: [])
    end

    create(unique_index(:users, [:email]))
  end

  def down do
    alter table(:users) do
      add(:avatar, :string)
      remove(:email)
      remove(:orgs)
    end
  end
end
