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
    plug Guardian.Plug.VerifyHelper, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", Customer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", Customer do
    pipe_through [:browser]

    get "/:provider", AuthController, :login
    get "/:provider/callback", AuthController, :callback
    delete "/", AuthController, :delete, as: :logout
  end

  scope "/api/", Customer do
    pipe_through [:api, :api_auth]

    resources "/companies", CompanyController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Customer do
  #   pipe_through :api
  # end
end
