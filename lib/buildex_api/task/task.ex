defmodule Buildex.API.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Buildex.API.Repository
  alias Ecto.Changeset
  alias Buildex.API.Encryption.EncryptedBinary

  schema "tasks" do
    field(:commands, {:array, :string}, default: [])
    # Plug.Upload - Dockerfile
    field(:build_file, :any, virtual: true)
    # Dockerfile content
    field(:build_file_content, :string)
    field(:docker_image_name, :string)
    field(:docker_image_tag_tmpl, :string)
    field(:env, :map, default: %{})
    field(:fetch_url, :string)
    field(:runner, :string)
    field(:source, :string)
    field(:path, :string, virtual: true)
    field(:ssh_key, EncryptedBinary)

    # Docker credentials
    field(:docker_username, :string)
    field(:docker_email, :string)
    field(:docker_password, EncryptedBinary)
    field(:docker_servername, :string, default: "https://index.docker.io/v1/")

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
      :build_file,
      :build_file_content,
      :commands,
      :repository_id,
      :docker_username,
      :docker_email,
      :docker_password,
      :docker_servername,
      :docker_image_name,
      :docker_image_tag_tmpl
    ])
    |> validate_required([:repository_id, :runner])
    |> validate_inclusion(:runner, ["make", "docker_build"])
    |> maybe_extract_build_file()
    |> maybe_validate_build_file_content()
    |> maybe_validate_docker_attributes()
    |> maybe_validate_source()
    |> foreign_key_constraint(:repository_id)
  end

  def update_changeset(task, attrs) do
    task
    |> cast(attrs, [
      :fetch_url,
      :ssh_key,
      :env,
      :build_file,
      :build_file_content,
      :commands,
      :docker_username,
      :docker_password,
      :docker_servername,
      :docker_image_name,
      :docker_image_tag_tmpl
    ])
    |> maybe_extract_build_file()
    |> maybe_validate_build_file_content()
    |> maybe_validate_docker_attributes()
    |> discard_empty_password()
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

  defp maybe_extract_build_file(%{valid?: false} = changeset), do: changeset

  defp maybe_extract_build_file(%{changes: %{build_file: upload}} = changeset) do
    content = File.read!(upload.path)
    put_change(changeset, :build_file_content, content)
  end

  defp maybe_extract_build_file(changeset), do: changeset

  @spec maybe_validate_docker_attributes(Changeset.t()) :: Changeset.t()
  defp maybe_validate_docker_attributes(%{valid?: false} = changeset), do: changeset

  defp maybe_validate_docker_attributes(%{changes: %{runner: "docker_build"}} = changeset) do
    validate_required(changeset, [
      :docker_username,
      :docker_password,
      :docker_servername,
      :docker_image_name
    ])
  end

  defp maybe_validate_docker_attributes(changeset), do: changeset

  @spec discard_empty_password(Changeset.t()) :: Changeset.t()
  defp discard_empty_password(changeset) do
    case get_change(changeset, :docker_passowrd) do
      empty when is_nil(empty) or empty == "" ->
        delete_change(changeset, :docker_password)

      _ ->
        changeset
    end
  end
end
