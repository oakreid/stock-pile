defmodule StockPileWeb.OtherController do
  use StockPileWeb, :controller

  def addfunds(conn, %{"amount" => amount}) do
    id = conn |> Map.from_struct() |> Map.get(:assigns) |> Map.get(:current_user) |> Map.get("account_id")
    account = StockPile.Tools.add_funds(to_string(amount), to_string(id))

    conn
    |> put_session(:account_id, Map.get(account, "account_id"))
    |> put_resp_header("content-type", "application/json; charset=UTF-8")
    |> send_resp(:ok, Jason.encode!(%{account_balance:  Map.get(account, "account_balance")}))
  end
end
