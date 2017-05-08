defmodule Customer.Web.Router do
  use Customer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", Customer.Web.Api do

    scope "/v1", V1 do
      pipe_through [:api]
      resources "/jobs", JobController, only: [:index, :show]
      resources "/tech-keywords", TechKeywordController, only: [:index]
    end

    scope "/v1", V1 do
      pipe_through [:api, :api_auth]
      scope "/auth" do
        delete "/", AuthController, :delete, as: :logout
      end

      resources "me/favorites/jobs", FavoriteJobController, except: [:new, :edit]
    end
  end

  scope "/", Customer.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index


    scope "/auth" do
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end

    get "/*path", PageController, :index
  end

end
