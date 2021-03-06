defmodule ChatWeb.Router do
  use ChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "text"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatWeb do
    pipe_through :browser # Use the default browser stack

    get "/chat", PageController, :index
    get "/test", PageController, :test
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true
  end

  scope "/cms", ChatWeb.CMS, as: :cms do
    pipe_through [:browser, :authenticate_user]

    resources "/pages", PageController
  end

  scope "/auth", ChatWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatWeb do
  #   pipe_through :api
  # end

  defp authenticate_user(conn, _) do
   case get_session(conn, :user_id) do
     nil ->
       conn
       |> Phoenix.Controller.put_flash(:error, "Login required")
       |> Phoenix.Controller.redirect(to: "/")
       |> halt()
     user_id ->
       assign(conn, :current_user, Chat.Accounts.get_user!(user_id))
   end
 end
end
