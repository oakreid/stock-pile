defmodule StockPileWeb.Router do
  use StockPileWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug StockPileWeb.Plugs.FetchSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StockPileWeb do
    pipe_through :browser

    resources "/sessions", SessionController, only: [:create, :delete], singleton: true

    get "/", PageController, :index
    get "/profile", PageController, :profile
    get "/register_broker", PageController, :registerbroker
    get "/register_dealer", PageController, :registerdealer
    get "/stocks", PageController, :stocks
    get "/investments", PageController, :investments

    post "/addfunds", PostController, :addfunds
    post "/register_broker", PostController, :registerbroker
    post "/register_dealer", PostController, :registerdealer
    post "/lookup_stock", PostController, :lookupstock
    post "/invest_dealer", PostController, :investdealer
    post "/invest_broker", PostController, :investbroker
    post "/sell_stock", PostController, :sellstock
  end

  # Other scopes may use custom stacks.
  # scope "/api", StockPileWeb do
  #   pipe_through :api
  # end
end
