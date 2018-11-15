defmodule ReleaseAdmin.Repo.Migrations.AddDockerAttributesForPush do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add(:docker_image_name, :string)
      add(:docker_image_tag_tmpl, :string)
    end
  end
end
