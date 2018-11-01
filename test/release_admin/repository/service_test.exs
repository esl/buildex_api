defmodule ReleaseAdmin.Repository.ServiceTest do
  use ReleaseAdmin.DataCase
  import ReleaseAdmin.Factory

  alias ReleaseAdmin.Repository.Service, as: RepositoryService

  describe "all/0" do
    test "gets all created repos" do
      insert_list(2, :repository)
      repos = RepositoryService.all()
      assert length(repos) == 2
    end
  end

  describe "get!/1" do
    test "gets a repo by id" do
      repo = insert(:repository)
      db_repo = RepositoryService.get!(repo.id)
      assert db_repo.id == repo.id
      assert db_repo.repository_url == repo.repository_url
    end

    test "raise if repo not found" do
      assert_raise Ecto.NoResultsError, fn ->
        RepositoryService.get!(123_456)
      end
    end
  end

  describe "create/1" do
    test "successfully creates a repository" do
      user = insert(:user)
      n = :rand.uniform(1_000)

      attrs = %{
        repository_url: "https://github.com/repo#{n}",
        polling_interval: 60,
        user_id: user.id
      }

      assert {:ok, repo} = RepositoryService.create(attrs)
      # assert created repo match attrs
      assert attrs = repo
    end

    test "doesn't create a repository" do
      attrs = %{polling_interval: 60}
      assert {:error, reason} = RepositoryService.create(attrs)
      assert %{repository_url: ["can't be blank"]} = errors_on(reason)
    end
  end

  describe "update/2" do
    test "updates already created repo" do
      repository = insert(:repository)
      new_attrs = %{github_token: "token", polling_interval: 3600}
      assert {:ok, repo} = RepositoryService.update(repository.id, new_attrs)
      # assert updated repo match new attrs
      assert new_attrs = repo
    end

    test "couldn't update non existent repo" do
      assert_raise Ecto.NoResultsError, fn ->
        RepositoryService.update(123_456, %{})
      end
    end

    test "can't update repo's url" do
      repository = insert(:repository)
      new_attrs = %{repository_url: "new_url"}
      assert {:ok, repo} = RepositoryService.update(repository.id, new_attrs)
      assert repo.repository_url == repository.repository_url
    end

    test "doesn't update repository" do
      repository = insert(:repository)
      new_attrs = %{polling_interval: nil}
      assert {:error, reason} = RepositoryService.update(repository.id, new_attrs)
      assert %{polling_interval: ["can't be blank"]} = errors_on(reason)
    end
  end

  describe "delete!/1" do
    test "deletes repo" do
      repository = insert(:repository)
      RepositoryService.delete!(repository.id)

      assert_raise Ecto.NoResultsError, fn ->
        RepositoryService.get!(repository.id)
      end
    end
  end
end
