defmodule BuildexApiWeb.Router do
  use BuildexApiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(BuildexApiWeb.Plugs.UserSession)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser_auth do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(BuildexApiWeb.Plugs.Authenticate)
    plug(BuildexApiWeb.Plugs.UserSession)
  end

  scope "/", BuildexApiWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/", BuildexApiWeb do
    pipe_through(:browser_auth)

    resources("/repos", RepositoriesController) do
      resources("/tasks", TaskController)
      resources("/poller", PollerController, only: [:create, :delete], singleton: true)
    end
  end

  scope "/auth", BuildexApiWeb do
    pipe_through(:browser)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end

  # Other scopes may use custom stacks.
  # scope "/api", BuildexApiWeb do
  #   pipe_through :api
  # end
end
