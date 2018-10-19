defmodule ReleaseAdmin.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias ReleaseAdmin.Repository
  alias Ecto.Changeset
  alias ReleaseAdmin.Encryption.EncryptedBinary

  schema "tasks" do
    field(:commands, {:array, :string}, default: [])
    field(:build_file_content, :string)
    field(:env, :map, default: %{})
    field(:fetch_url, :string)
    field(:runner, :string)
    field(:source, :string)
    field(:ssh_key, EncryptedBinary)

    belongs_to(:repository, Repository)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :fetch_url,
      :ssh_key,
      :runner,
      :source,
      :env,
      :build_file_content,
      :commands,
      :repository_id
    ])
    |> validate_required([:repository_id, :runner])
    |> validate_inclusion(:runner, ["make", "docker_build"])
    |> maybe_validate_build_file_content()
    |> maybe_validate_source()
  end

  @spec maybe_validate_build_file_content(Changeset.t()) :: Changeset.t()
  defp maybe_validate_build_file_content(%{valid?: false} = changeset), do: changeset

  defp maybe_validate_build_file_content(%{changes: %{runner: "docker_build"}} = changeset) do
    validate_required(changeset, :build_file_content)
  end

  defp maybe_validate_build_file_content(changeset), do: changeset

  @spec maybe_validate_source(Changeset.t()) :: Changeset.t()
  defp maybe_validate_source(%{valid?: false} = changeset), do: changeset

  defp maybe_validate_source(%{changes: %{runner: "make"}} = changeset) do
    validate_required(changeset, :source)
  end

  defp maybe_validate_source(changeset), do: changeset
end
