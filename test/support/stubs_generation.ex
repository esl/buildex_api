defmodule ReleaseAdminWeb.StubsGeneration do
  def generate_github_auth_response do
    git_id = :rand.uniform(1_000_000)

    github_oauth = %Ueberauth.Auth{
      credentials: %Ueberauth.Auth.Credentials{
        token: "verylargelargetoken"
      },
      info: %Ueberauth.Auth.Info{
        email: "test-email@ex.com",
        image: "https://avatars0.githubusercontent.com/u/#{git_id}?v=4",
        nickname: "kirobyte",
        urls: %{
          avatar_url: "https://avatars0.githubusercontent.com/u/#{git_id}?v=4"
        }
      },
      provider: :github,
      uid: git_id
    }

    github_oauth
  end
end
