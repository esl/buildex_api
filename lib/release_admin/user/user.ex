defmodule ReleaseAdmin.User do
  use Ecto.Schema
  import Ecto.{Query, Changeset}

  alias __MODULE__
  alias ReleaseAdmin.Repository

  schema "users" do
    field(:avatar, :string)
    field(:username, :string)

    has_many(:repos, Repository)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :username, :avatar])
    |> validate_required([:id, :username])
    |> unique_constraint(:username)
    |> unique_constraint(:id)
  end

  def new() do
    %User{}
  end

  @spec by_username(String.t()) :: Ecto.Query.t()
  def by_username(username) do
    from u in User, where: u.username == ^username
  end
end
