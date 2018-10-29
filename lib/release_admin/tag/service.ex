defmodule ReleaseAdmin.Tag.Service do
  alias ReleaseAdmin.{Repo, Repository, Tag}

  @spec repo_tags(Repository.t() | String.t()) :: list(Tag.t())
  def repo_tags(%Repository{} = repo) do
    repo = Repo.preload(repo, :tags)
    repo.tags
  end

  def repo_tags(url) when is_binary(url) do
    repo =
      Repository
      |> Repo.get_by!(repository_url: url)
      |> Repo.preload(:tags)

    repo.tags
  end

  @spec get_tag!(String.t() | non_neg_integer()) :: Tag.t()
  def get_tag!(id), do: Repo.get!(Tag, id)

  @spec create_tag(String.t(), map()) :: {:ok, Tag.t()} | {:error, Ecto.Changeset.t()}
  def create_tag(url, attrs \\ %{}) do
    repo =
      Repository
      |> Repo.get_by!(repository_url: url)

    attrs = Map.merge(attrs, %{repository_id: repo.id})

    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @spec delete_tag!(Tag.t()) :: Tag.t() | no_return()
  def delete_tag!(%Tag{} = tag), do: Repo.delete!(tag)
end
