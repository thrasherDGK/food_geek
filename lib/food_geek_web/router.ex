defmodule FoodGeekWeb.Router do
  use FoodGeekWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug :basic_auth, Application.compile_env(:food_geek, :auth_config)

    plug FoodGeekWeb.SetLocalePlug
    plug FoodGeekWeb.SetCurrentUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate_user do
    plug FoodGeekWeb.AuthPlug
  end

  scope "/", FoodGeekWeb do
    pipe_through :browser

    get "/contact", PageController, :contact
    get "/terms", PageController, :terms

    get "/sign-in", SessionController, :new
    post "/sign-in", SessionController, :create
    delete "/sign-out", SessionController, :delete

    get "/sign-up", RegistrationController, :new
    post "/sign-up", RegistrationController, :create

    get "/", RecipeController, :index
    get "/:id", RecipeController, :show
  end

  scope "/my", FoodGeekWeb.My, as: :my do
    pipe_through [:browser, :authenticate_user]

    resources "/profile", ProfileController,
      only: [:show],
      singleton: true

    resources "/recipes", RecipeController do
      resources "/publication", PublicationController,
        only: [:create, :delete],
        singleton: true
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", FoodGeekWeb do
  #   pipe_through :api
  # end
end
