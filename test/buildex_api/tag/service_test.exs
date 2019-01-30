defmodule Buildex.API.Tag.ServiceTest do
  use Buildex.API.DataCase
  import Buildex.API.Factory

  alias Buildex.API.Tag.Service, as: TagService

  setup do
    repo = insert(:repository)
    {:ok, repo: repo}
  end

  describe "repo_tags/1" do
    test "gets repo tags by repo", %{repo: repo} do
      insert_list(2, :tag, repository: repo)
      tags = TagService.repo_tags(repo)
      assert length(tags) == 2
    end

    test "gets repo tags by repository url", %{repo: repo} do
      insert_list(2, :tag, repository: repo)
      tags = TagService.repo_tags(repo.repository_url)
      assert length(tags) == 2
    end
  end

  describe "get_tag!/1" do
    test "gets tag by id", %{repo: repo} do
      tag = insert(:tag, repository: repo)
      db_tags = TagService.get_tag!(tag.id)
      assert db_tags.name == tag.name
      assert db_tags.commit_sha == tag.commit_sha
    end
  end

  describe "create_tag/2" do
    test "successfully creates a tag and assigns it to a repo by it's url", %{repo: repo} do
      version = :rand.uniform(1_000)

      attrs = %{
        name: "v#{version}.0.0",
        commit: %{
          sha: "commit_sha",
          url: "https://github.com/commit_sha"
        }
      }

      assert {:ok, tag} = TagService.create_tag(repo.repository_url, attrs)
      assert tag.repository_id == repo.id
      assert tag.name == attrs[:name]
      assert tag.commit_sha == attrs[:commit][:sha]
    end

    test "doesn't create a task", %{repo: repo} do
      version = :rand.uniform(1_000)
      attrs = %{name: "v#{version}.0.0"}
      assert {:error, reason} = TagService.create_tag(repo.repository_url, attrs)
      assert %{commit_sha: ["can't be blank"]} = errors_on(reason)
    end
  end

  describe "delete_tag!/1" do
    test "deletes tag", %{repo: repo} do
      tag = insert(:tag, repository: repo)
      TagService.delete_tag!(tag)

      assert_raise Ecto.NoResultsError, fn ->
        TagService.get_tag!(tag.id)
      end
    end
  end
end
