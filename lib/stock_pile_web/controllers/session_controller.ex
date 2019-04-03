defmodule StockPileWeb.SessionController do
  use StockPileWeb, :controller

  def create(conn, %{"user_name" => user_name, "password" => password}) do
    account = StockPile.Tools.auth_user(user_name, password)
    if account do
      conn
      |> put_session(:account_id, Map.get(account, "account_id"))
      |> put_flash(:info, "Welcome back #{Map.get(account, "user_name")}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:account_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
