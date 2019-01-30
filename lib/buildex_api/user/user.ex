defmodule Buildex.API.User do
  use Ecto.Schema
  import Ecto.{Query, Changeset}

  alias __MODULE__
  alias Buildex.API.Repository

  schema "users" do
    field(:email, :string)
    field(:username, :string)
    field(:orgs, {:array, :string}, default: [])

    has_many(:repos, Repository)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :username, :email, :orgs])
    |> validate_required([:id, :username, :email])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> unique_constraint(:id)
  end

  def new() do
    %User{}
  end

  @spec by_username(String.t()) :: Ecto.Query.t()
  def by_username(username) do
    from(u in User, where: u.username == ^username)
  end
end
