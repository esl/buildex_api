defmodule ReleaseAdmin.TagTest do
  use ReleaseAdmin.DataCase
  import Ecto.Changeset

  alias ReleaseAdmin.{Repo, Tag}

  describe "validations" do
    test "validates commit_sha is required" do
      assert {:error, reason} =
               %Tag{}
               |> Tag.changeset(%{})
               |> Repo.insert()

      assert %{commit_sha: ["can't be blank"]} = errors_on(reason)
    end

    test "validates commit_url is required" do
      assert {:error, reason} =
               %Tag{}
               |> Tag.changeset(%{})
               |> Repo.insert()

      assert %{commit_url: ["can't be blank"]} = errors_on(reason)
    end

    test "validates tag name is required" do
      assert {:error, reason} =
               %Tag{}
               |> Tag.changeset(%{})
               |> Repo.insert()

      assert %{name: ["can't be blank"]} = errors_on(reason)
    end
  end

  test "maps commit's sha/url from commit map" do
    attrs = %{
      "repository_id" => 1,
      "commit" => %{
        "sha" => "c5b97d5ae6c19d5c5df71a34c7fbeeda2479ccbc",
        "url" =>
          "https://api.github.com/repos/octocat/Hello-World/commits/c5b97d5ae6c19d5c5df71a34c7fbeeda2479ccbc"
      }
    }

    changeset =
      %Tag{}
      |> Tag.changeset(attrs)

    assert get_change(changeset, :commit_sha) == "c5b97d5ae6c19d5c5df71a34c7fbeeda2479ccbc"

    assert get_change(changeset, :commit_url) ==
             "https://api.github.com/repos/octocat/Hello-World/commits/c5b97d5ae6c19d5c5df71a34c7fbeeda2479ccbc"
  end
end
