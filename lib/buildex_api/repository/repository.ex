defmodule Buildex.API.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  alias Buildex.API.{User, Tag, Task}

  @adapters ["github"]

  schema "repos" do
    field(:github_token, :string)
    field(:polling_interval, :integer)
    field(:repository_url, :string)
    field(:adapter, :string, default: "github")

    has_many(:tags, Tag)
    has_many(:tasks, Task)
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(repo, attrs) do
    repo
    |> cast(attrs, [:repository_url, :polling_interval, :github_token, :user_id, :adapter])
    |> validate_required([:repository_url, :polling_interval, :user_id])
    |> validate_inclusion(:adapter, @adapters)
    |> unique_constraint(:repository_url)
  end

  def update_changeset(repo, attrs) do
    repo
    |> cast(attrs, [:polling_interval, :github_token])
    |> validate_required([:polling_interval])
  end
end
