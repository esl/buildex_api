defmodule ReleaseAdmin.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias ReleaseAdmin.Repository

  schema "tags" do
    field(:commit_sha, :string)
    field(:commit_url, :string)
    field(:commit, :map, virtual: true)
    field(:name, :string)
    field(:node_id, :string)
    field(:tarball_url, :string)
    field(:zipball_url, :string)

    belongs_to(:repository, Repository)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name, :node_id, :commit, :zipball_url, :tarball_url, :repository_id])
    |> map_commit_info()
    |> validate_required([:name, :commit_sha, :commit_url, :repository_id])
    |> unique_constraint(:name,
      name: :tags_repository_id_name_index,
      message: "Tag is already created"
    )
  end

  defp map_commit_info(%{valid?: false} = changeset), do: changeset

  defp map_commit_info(%{changes: %{commit: commit}} = changeset) do
    %{sha: sha, url: url} = commit

    changeset
    |> put_change(:commit_sha, sha)
    |> put_change(:commit_url, url)
  end

  defp map_commit_info(changeset), do: changeset
end
