defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug AppWeb.Plugs.GraphQLUserContext
  end

  scope "/api" do
    pipe_through :api

    forward "/", Absinthe.Plug, #.GraphiQL,
      schema: AppWeb.API#,
      # socket: AppWeb.UserSocket,
      # interface: :simple
  end

  if Mix.env == :dev do
    forward "/emails", Bamboo.EmailPreviewPlug
  end

  scope "/", AppWeb do
    pipe_through :browser # Use the default browser stack

    forward "/", Plugs.StaticPlug
  end

end
