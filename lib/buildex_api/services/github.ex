defmodule Buildex.API.Services.Github do
  @spec get_user_organizations(String.t()) :: {:ok | integer(), any(), HTTPoison.Response.t()}
  def get_user_organizations(access_token) do
    client = Tentacat.Client.new(%{access_token: access_token})
    Tentacat.Organizations.list_mine(client)
  end
end
