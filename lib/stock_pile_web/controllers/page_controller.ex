defmodule StockPileWeb.PageController do
  use StockPileWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def profile(conn, _params) do
    render(conn, "profile.html")
  end

  def registerbroker(conn, _params) do
    render(conn, "register_broker.html")
  end

  def registerdealer(conn, _params) do
    render(conn, "register_dealer.html")
  end

  def stocks(conn, _params) do
    render(conn, "stocks.html")
  end

  def investments(conn, _params) do
    render(conn, "investments.html")
  end
end
