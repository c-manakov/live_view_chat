defmodule TestCasePhoenixWeb.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router


  pipeline :maybe_browser_auth do
    plug(TestCasePhoenix.AuthPipeline)
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TestCasePhoenixWeb do
    pipe_through [:browser, :maybe_browser_auth]

    post "/user", UserController, :create

    get "/logout", UserController, :logout

    live "/login", Login
  end

  scope "/", TestCasePhoenixWeb do
    pipe_through [:browser, :maybe_browser_auth, :ensure_auth]

    live "/", Chat, session: [:guardian_default_token]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TestCasePhoenixWeb do
  #   pipe_through :api
  # end
end
