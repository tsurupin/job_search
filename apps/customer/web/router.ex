defmodule Customer.Router do
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
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", Customer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    scope "/auth" do
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end

  end

  scope "/api", Customer.Api do

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

      resources "/favorite-jobs", FavoriteJobController, only: [:index, :create, :delete, :update]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Customer do
  #   pipe_through :api
  # end
end
