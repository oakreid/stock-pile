defmodule StockPileWeb.PostController do
  use StockPileWeb, :controller
  alias StockPile.Tools

  def addfunds(conn, %{"amount" => amount}) do
    id = conn |> Map.from_struct() |> Map.get(:assigns) |> Map.get(:current_user) |> Map.get("account_id")
    account = Tools.add_funds(to_string(amount), to_string(id))

    conn
    |> put_session(:account_id, Map.get(account, "account_id"))
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(:ok, Jason.encode!(%{account_balance:  Map.get(account, "account_balance")}))
  end

  def registerbroker(conn, %{"account" => account}) do
    register_account = Tools.register_broker(account)
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(elem(register_account, 0), Jason.encode!(%{}))
  end

  def registerdealer(conn, %{"account" => account}) do
    IO.puts(inspect(account))
    register_account = Tools.register_dealer(account)
    conn
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(elem(register_account, 0), Jason.encode!(%{}))
  end

  def lookupstock(conn, %{"ticker_val" => ticker_val}) do
    stock_info = Tools.lookup_stock(ticker_val)
    case stock_info do
      {stock_singular_info, {:ok, query_result}} ->
        query_map = Map.from_struct(query_result)
        table_data = [tl(Map.get(query_map, :columns)) | Enum.map(Map.get(query_map, :rows), fn(x) -> tl(x) end)]
        resp = %{
          info: stock_singular_info,
          data: table_data
        }
        conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:ok, Jason.encode!(resp))
      _ ->
        conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:error, Jason.encode!(%{}))
    end
  end

  def investdealer(conn, %{"trade_order" => trade_order}) do
    invest_result = Tools.invest_dealer(trade_order)
    case invest_result do
      {:ok, _query_result} ->
        resp = %{}
        conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:ok, Jason.encode!(resp))
      _ ->
        conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:error, Jason.encode!(%{}))
    end
  end

  def sellstock(conn, %{"trade_id" => trade_id, "account_id" => account_id, "date" => date}) do
    sell_result = Tools.sell_stock(trade_id, account_id, date)
    case sell_result do
      {:ok, _query_result} ->
        resp = %{}
        conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:ok, Jason.encode!(resp))
      _ ->
        conn
        |> put_resp_header("content-type", "application/json; charset=UTF-8")
        |> send_resp(:error, Jason.encode!(%{}))
    end
  end
end
