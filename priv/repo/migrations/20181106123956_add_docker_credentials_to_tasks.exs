defmodule ReleaseAdmin.Repo.Migrations.AddDockerCredentialsToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      # TODO conditional null constraint for username or email
      add(:docker_username, :string)
      add(:docker_email, :string)
      add(:docker_password, :binary)
      add(:docker_servername, :string)
    end
  end
end
