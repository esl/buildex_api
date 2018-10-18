defmodule ReleaseAdmin.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  alias ReleaseAdmin.{User, Tag}

  schema "repos" do
    field(:github_token, :string)
    field(:polling_interval, :integer)
    field(:repository_url, :string)

    has_many(:tags, Tag)
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(repo, attrs) do
    repo
    |> cast(attrs, [:repository_url, :polling_interval, :github_token, :user_id])
    |> validate_required([:repository_url, :polling_interval, :user_id])
    |> unique_constraint(:repository_url)
  end

  def update_changeset(repo, attrs) do
    repo
    |> cast(attrs, [:polling_interval, :github_token])
    |> validate_required([:polling_interval])
  end
end
