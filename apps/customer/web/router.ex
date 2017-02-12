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
    pipe_through [:api, :api_auth]

    scope "/v1", V1 do
      scope "/auth" do

        delete "/", AuthController, :delete, as: :logout
      end

      resources "/companies", CompanyController
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", Customer do
  #   pipe_through :api
  # end
end
