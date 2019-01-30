defmodule Buildex.API.Repository.Service do
  alias Buildex.API.{Repo, Repository}

  @spec all() :: list(Repository.t())
  def all() do
    Repo.all(Repository)
  end

  @spec get!(non_neg_integer() | String.t()) :: Repository.t() | no_return()
  def get!(id) do
    Repo.get!(Repository, id)
  end

  @spec create(map()) :: {:ok, Repository.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  @spec update(non_neg_integer() | String.t(), map()) ::
          {:ok, Repository.t()} | {:error, Ecto.Changeset.t()} | no_return()
  def update(id, attrs) do
    id
    |> get!()
    |> Repository.update_changeset(attrs)
    |> Repo.update()
  end

  @spec delete!(non_neg_integer() | String.t()) :: Repository.t() | no_return()
  def delete!(id) do
    id
    |> get!()
    |> Repo.delete!()
  end
end
