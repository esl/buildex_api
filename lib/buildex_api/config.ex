defmodule Buildex.API.Config do
  def db_secret_key do
    secret_key = get_val!(:db_secret_key)

    case byte_size(secret_key) do
      32 ->
        secret_key

      other ->
        raise "secret_key must be 32 bytes in length - is #{inspect(other)} generate an appropriate key using `32 |> :crypto.strong_rand_bytes() |> Base.encode64()`"
    end
  end

  def get_poller_domain do
    Node.list()
    |> Enum.filter(fn node ->
      node
      |> Atom.to_string()
      |> String.starts_with?("poller")
    end)
    |> Enum.random()
  end

  def get_rpc_impl do
    get_val!(:rpc_impl)
  end

  defp get_val!(key) when is_atom(key) do
    case Confex.fetch_env!(:buildex_api, key) do
      nil -> raise("cannot resolve  Application.get_env(:buildex_api, #{inspect(key)}) ")
      other -> other
    end
  end

  def base64decode(value) do
    {:ok, value |> Base.decode64!()}
  rescue
    e in ArgumentError -> {:error, e.message}
  end
end
