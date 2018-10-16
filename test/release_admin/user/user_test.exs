defmodule ReleaseAdmin.UserTest do
  use ReleaseAdmin.DataCase
  import ReleaseAdmin.Factory

  alias ReleaseAdmin.{Repo, User}

  describe "validations" do
    test "validates uniqueness of username" do
      insert(:user, username: "kiro")

      assert {:error, reason} =
               User.new()
               |> User.changeset(%{username: "kiro", id: :rand.uniform(1_000_000)})
               |> Repo.insert()

      assert %{username: ["has already been taken"]} = errors_on(reason)
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
end