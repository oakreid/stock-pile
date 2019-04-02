defmodule StockPileWeb.SessionController do
  use StockPileWeb, :controller

  def create(conn, %{"user_name" => user_name}) do
    account = StockPile.Tools.get_account_by_user_name(user_name)
    if account do
      conn
      |> put_session(:account_id, account.account_id)
      |> put_flash(:info, "Welcome back #{account.user_name}")
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
