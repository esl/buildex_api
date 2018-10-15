defmodule ReleaseAdmin.Auth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  require Logger
  require Poison

  alias Ueberauth.Auth
  alias ReleaseAdmin.{User, Repo}

  @spec find_or_create(Auth.t()) :: {:error, String.t()} | {:ok, Ecto.Changeset.t()}
  def find_or_create(%Auth{provider: :github} = auth) do
    case validate_organization(auth) do
      :ok ->
        {:ok, basic_info(auth)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def find_or_create(_auth), do: {:error, "Invalid Auth Provider"}

  defp basic_info(auth) do
    attrs = %{id: auth.uid, username: username_from_auth(auth), avatar: avatar_from_auth(auth)}

    User.by_username(attrs.username)
    |> Repo.one()
    |> case do
      nil -> User.new()
      user -> user
    end
    |> User.changeset(attrs)
    |> Repo.insert_or_update()
  end

  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  defp username_from_auth(%{info: %{nickname: nickname}}), do: nickname

  # TODO: figure out how to validate membership to a given org
  defp validate_organization(_auth), do: :ok
end
