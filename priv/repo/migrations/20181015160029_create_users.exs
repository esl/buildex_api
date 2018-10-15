defmodule ReleaseAdmin.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      # don't autoincrement ids
      add(:id, :integer, primary_key: true)
      add(:username, :string, null: false)
      add(:avatar, :string)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:users, [:username]))
  end
end
