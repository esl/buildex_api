defmodule Buildex.API.UserTest do
  use Buildex.API.DataCase
  import Buildex.API.Factory

  alias Buildex.API.{Repo, User}

  describe "validations" do
    test "validates uniqueness of username" do
      insert(:user, username: "kiro")

      assert {:error, reason} =
               User.new()
               |> User.changeset(%{
                 username: "kiro",
                 email: "test@ex.com",
                 id: :rand.uniform(1_000_000)
               })
               |> Repo.insert()

      assert %{username: ["has already been taken"]} = errors_on(reason)
    end

    test "validates uniqueness of email" do
      insert(:user, email: "kiro@ex.com")

      assert {:error, reason} =
               User.new()
               |> User.changeset(%{
                 username: "test",
                 email: "kiro@ex.com",
                 id: :rand.uniform(1_000_000)
               })
               |> Repo.insert()

      assert %{email: ["has already been taken"]} = errors_on(reason)
    end

    test "validates username is required" do
      assert {:error, reason} =
               User.new()
               |> User.changeset(%{id: :rand.uniform(1_000_000)})
               |> Repo.insert()

      assert %{username: ["can't be blank"]} = errors_on(reason)
    end

    test "validates id is required" do
      assert {:error, reason} =
               User.new()
               |> User.changeset(%{username: "kiro"})
               |> Repo.insert()

      assert %{id: ["can't be blank"]} = errors_on(reason)
    end

    test "validates email is required" do
      assert {:error, reason} =
               User.new()
               |> User.changeset(%{username: "kiro"})
               |> Repo.insert()

      assert %{email: ["can't be blank"]} = errors_on(reason)
    end
  end

  describe "queries" do
    test "find by username" do
      insert(:user, username: "kiro")

      assert %{username: "kiro"} =
               User.by_username("kiro")
               |> Repo.one()
    end

    test "won't find anything by username" do
      refute User.by_username("pluto")
             |> Repo.one()
    end
  end

  describe "defaults" do
    test "user's organizations is default to and empty list" do
      assert %{orgs: []} = User.new()
    end
  end
end
