defmodule StockPileWeb.OtherController do
  use StockPileWeb, :controller
  alias StockPileWeb.SessionController
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
    _side_effect = Tools.register_broker(account)

    SessionController.create(conn, %{"user_name" => Map.get(account, "user_name"), "password" => Map.get(account, "password")})
  end

  def registerdealer(conn, %{"account" => account}) do
    _side_effect = Tools.register_dealer(account)

    SessionController.create(conn, %{"user_name" => Map.get(account, "user_name"), "password" => Map.get(account, "password")})
  end
end
