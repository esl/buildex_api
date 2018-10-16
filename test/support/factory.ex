defmodule ReleaseAdmin.Factory do
  use ExMachina.Ecto, repo: ReleaseAdmin.Repo

  alias ReleaseAdmin.{Repository, User, Tag}

  @spec user_factory() :: User.t()
  def user_factory do
    %User{
      # Ids are taken from GitHub's Ids so we aren't autogenerating them
      id: :rand.uniform(1_000_000),
      username: sequence(:username, &"username-#{&1}")
    }
  end

  @spec repository_factory() :: Repository.t()
  def repository_factory do
    %Repository{
      repository_url: sequence(:url, &"http://github.com/repo_owner#{&1}/r_name"),
      polling_interval: :rand.uniform(3600),
      user: build(:user)
    }
  end

  @spec tag_factory() :: Tag.t()
  def tag_factory() do
    %Tag{
      name: sequence(:name, &"v#{&1}.0.0"),
      commit_sha: "commit_sha",
      commit_url: "https://github.com/commit_sha",
      repository: build(:repository)
    }
  end
end
