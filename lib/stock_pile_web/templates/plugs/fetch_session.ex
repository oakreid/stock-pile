defmodule StockPileWeb.Plugs.FetchSession do
  import Plug.Conn

  def init(args), do: args

  def call(conn, _args) do
    account = StockPile.Tools.get_account_by_id(get_session(conn, :account_id) || -1)
    if account do
      assign(conn, :current_user, account)
    else
      assign(conn, :current_user, nil)
    end
  end
end
