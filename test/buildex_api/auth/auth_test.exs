defmodule Buildex.API.AuthTest do
  use Buildex.API.DataCase
  import Mimic
  import Buildex.API.Factory

  alias Buildex.API.{Auth, User}
  alias Buildex.API.Services.Github
  alias Buildex.API.Auth.Session

  alias Buildex.API.Web.StubsGeneration

  setup :verify_on_exit!

  setup do
    {:ok, github_oauth: StubsGeneration.generate_github_auth_response()}
  end

  describe "new/1" do
    test "invalid provider" do
      assert {:error, :invalid_provider} = Auth.new(%Ueberauth.Auth{provider: :facebook})
    end

    test "setups auth struct", %{github_oauth: github_oauth} do
      assert {:ok, auth} = Auth.new(github_oauth)

      assert %Auth{
               id: git_id,
               username: "kirobyte",
               email: "test-email@ex.com",
               access_token: "verylargelargetoken",
               orgs: []
             } = auth
    end
  end

  describe "find_or_create/1" do
    test "failure fetching orgs", %{github_oauth: github_oauth} do
      Github
      |> stub(:get_user_organizations, fn _ -> {:error, :failed} end)

      {:ok, auth} = Auth.new(github_oauth)
      assert {:error, :forbidden} = Auth.find_or_create(auth)
    end

    test "user doesn't belongs to provided org", %{github_oauth: github_oauth} do
      Github
      |> stub(:get_user_organizations, fn _ -> {200, [], nil} end)

      {:ok, auth} = Auth.new(github_oauth)
      assert {:error, :forbidden} = Auth.find_or_create(auth)
    end

    test "creates new user", %{github_oauth: github_oauth} do
      Github
      |> stub(:get_user_organizations, fn _ -> {200, [%{"login" => "esl"}], nil} end)

      {:ok, auth} = Auth.new(github_oauth)
      assert {:ok, user} = Auth.find_or_create(auth)
      refute is_nil(user.id)

      assert %User{
               email: "test-email@ex.com",
               username: "kirobyte",
               orgs: ["esl"]
             } = user
    end

    test "updates user", %{github_oauth: github_oauth} do
      insert(:user, username: "kirobyte", email: "test-email@ex.com")

      Github
      |> stub(:get_user_organizations, fn _ -> {200, [%{"login" => "esl"}], nil} end)

      {:ok, auth} = Auth.new(github_oauth)
      assert {:ok, user} = Auth.find_or_create(auth)

      assert %User{
               email: "test-email@ex.com",
               username: "kirobyte",
               orgs: ["esl"]
             } = user
    end

    test "error creating user", %{github_oauth: github_oauth} do
      Github
      |> stub(:get_user_organizations, fn _ -> {200, [%{"login" => "esl"}], nil} end)

      {:ok, auth} = Auth.new(github_oauth)

      assert {:error, reason} =
               auth
               |> Map.put(:username, "")
               |> Auth.find_or_create()

      assert %{username: ["can't be blank"]} = errors_on(reason)
    end
  end

  describe "new_session/1" do
    test "create a new session from the auth struct", %{github_oauth: github_oauth} do
      {:ok, auth} = Auth.new(github_oauth)
      assert %Session{username: "kirobyte", email: "test-email@ex.com"} == Auth.new_session(auth)
    end
  end
end
