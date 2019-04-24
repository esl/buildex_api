defmodule Buildex.API.Web.Router do
  use Buildex.API.Web, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Buildex.API.Web.Plugs.UserSession)
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
    plug(Buildex.API.Web.Plugs.Authenticate)
    plug(Buildex.API.Web.Plugs.UserSession)
  end

  scope "/", Buildex.API.Web do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/", Buildex.API.Web do
    pipe_through(:browser_auth)

    resources("/repos", RepositoriesController) do
      resources("/tasks", TaskController)
      resources("/poller", PollerController, only: [:create, :delete], singleton: true)
    end
  end

  scope "/auth", Buildex.API.Web do
    pipe_through(:browser)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end

end
