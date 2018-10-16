defmodule ReleaseAdmin.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  alias ReleaseAdmin.{User, Tag}

  schema "repos" do
    field(:github_token, :string)
    field(:name, :string)
    field(:owner, :string)
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
    |> parse_repository_url()
    |> unique_constraint(:repository_url)
    |> unique_constraint(:owner, name: :repos_owner_name_index)
  end

  defp parse_repository_url(%{valid?: false} = changeset), do: changeset

  defp parse_repository_url(%{changes: %{repository_url: repository_url}} = changeset) do
    %{path: path} = URI.parse(repository_url)

    [owner, name] =
      path
      |> String.replace_leading("/", "")
      |> String.split("/")

    changeset
    |> put_change(:owner, owner)
    |> put_change(:name, name)
  end
end
