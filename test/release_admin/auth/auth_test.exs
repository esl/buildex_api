defmodule ReleaseAdmin.AuthTest do
  use ReleaseAdmin.DataCase
  import Mimic
  import ReleaseAdmin.Factory

  alias ReleaseAdmin.{Auth, User}
  alias ReleaseAdmin.Services.Github

  setup :verify_on_exit!

  setup do
    git_id = :rand.uniform(1_000_000)

    github_oauth = %Ueberauth.Auth{
      credentials: %Ueberauth.Auth.Credentials{
        token: "verylargelargetoken",
        token_type: "Bearer"
      },
      extra: %Ueberauth.Auth.Extra{
        raw_info: %{
          token: %OAuth2.AccessToken{
            access_token: "verylargelargetoken",
            token_type: "Bearer"
          },
          user: %{
            "id" => git_id,
            "avatar_url" => "https://avatars0.githubusercontent.com/u/#{git_id}?v=4",
            "emails" => [
              %{
                "email" => "test-email@ex.com",
                "primary" => true,
                "verified" => true,
                "visibility" => "public"
              }
            ],
            "type" => "User",
            "name" => "Kiro",
            "email" => "test-email@ex.com",
            "login" => "kirobyte"
          }
        }
      },
      info: %Ueberauth.Auth.Info{
        email: "test-email@ex.com",
        image: "https://avatars0.githubusercontent.com/u/#{git_id}?v=4",
        location: "Medellin",
        name: "Kiro",
        nickname: "kirobyte",
        urls: %{
          avatar_url: "https://avatars0.githubusercontent.com/u/#{git_id}?v=4"
        }
      },
      provider: :github,
      uid: git_id
    }

    {:ok, github_oauth: github_oauth}
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
end
