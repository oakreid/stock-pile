defmodule StockPileWeb.PageController do
  use StockPileWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def profile(conn, _params) do
    render(conn, "profile.html")
  end

  # TODO: don't forget to put_session when you make user register
end
