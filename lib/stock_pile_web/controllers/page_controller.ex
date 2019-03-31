defmodule StockPileWeb.PageController do
  use StockPileWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
