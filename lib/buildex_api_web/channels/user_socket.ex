defmodule Buildex.API.Web.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", Buildex.API.Web.RoomChannel

  ## Transports
  # transport(:websocket, Phoenix.Transports.WebSocket)

  # Instead of defining transports in your socket.ex file:

  # transport :websocket, Phoenix.Transport.Websocket,
  #   key1: value1, key2: value2, key3: value3

  # transport :longpoll, Phoenix.Transport.LongPoll,
  #   key1: value1, key2: value2, key3: value3

  # You should configure websocket/longpoll in your endpoint.ex:

  # socket "/socket", MyApp.UserSocket,
  #   websocket: [key1: value1, key2: value2, key3: value3],
  #   longpoll: [key1: value1, key2: value2, key3: value3]

  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(_params, socket) do
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Buildex.API.Web.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
