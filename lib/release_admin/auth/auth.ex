defmodule ReleaseAdmin.Auth do
  @moduledoc """
  Retrieve the user information from an auth request
  """
  alias __MODULE__
  alias ReleaseAdmin.{User, Repo}
  alias ReleaseAdmin.Auth.Session
  alias ReleaseAdmin.Services.Github

  @type t :: %__MODULE__{
          id: pos_integer(),
          username: String.t(),
          email: String.t(),
          avatar: String.t(),
          access_token: String.t(),
          orgs: list(String.t())
        }

  defstruct id: nil, username: nil, email: nil, avatar: nil, access_token: nil, orgs: []

  @spec new(Ueberauth.Auth.t()) :: {:ok, Auth.t()} | {:error, :invalid_provider}
  def new(%Ueberauth.Auth{provider: :github} = auth) do
    primary_email =
      emails_from_auth(auth)
      |> Enum.find(& &1["primary"])
      |> (fn
            nil -> nil
            auth_email -> auth_email["email"]
          end).()

    access_token = access_token_from_auth(auth)

    {:ok,
     %Auth{
       id: auth.uid,
       username: username_from_auth(auth),
       email: primary_email,
       avatar: avatar_from_auth(auth),
       access_token: access_token
     }}
  end

  def new(_auth), do: {:error, :invalid_provider}

  @spec find_or_create(Auth.t()) :: {:error, :forbidden | Ecto.Changeset.t()} | {:ok, User.t()}
  def find_or_create(%Auth{} = auth) do
    case validate_organization(auth) do
      {:ok, augmented_auth} ->
        do_find_or_create(augmented_auth)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec new_session(Auth.t()) :: Session.t()
  def new_session(%Auth{username: username, email: email}) do
    Session.new(username, email)
  end

  defp do_find_or_create(%{username: username} = auth) do
    attrs = Map.from_struct(auth)

    User.by_username(username)
    |> Repo.one()
    |> case do
      nil -> User.new()
      user -> user
    end
    |> User.changeset(attrs)
    |> Repo.insert_or_update()
  end

  defp avatar_from_auth(%{info: %{urls: %{avatar_url: image}}}), do: image

  defp username_from_auth(%{extra: %{raw_info: %{user: %{"login" => username}}}}), do: username

  defp emails_from_auth(%{extra: %{raw_info: %{user: %{"emails" => emails}}}}), do: emails

  defp access_token_from_auth(%{credentials: %{token: access_token}}), do: access_token

  defp validate_organization(%{access_token: access_token} = auth) do
    case Github.get_user_organizations(access_token) do
      {200, orgs, _} ->
        org_names = Enum.map(orgs, & &1["login"])

        # TODO: made this configurable
        if Enum.member?(org_names, "esl") do
          {:ok, %{auth | orgs: org_names}}
        else
          {:error, :forbidden}
        end

      _ ->
        {:error, :forbidden}
    end
  end
end
