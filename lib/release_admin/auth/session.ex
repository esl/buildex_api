defmodule ReleaseAdmin.Auth.Session do
  alias __MODULE__

  @enforce_keys [:username, :email]

  @type t :: %__MODULE__{
          username: String.t(),
          email: String.t()
        }

  defstruct username: nil, email: nil

  @spec new(String.t(), String.t()) :: Session.t()
  def new(username, email) do
    %Session{username: username, email: email}
  end
end
