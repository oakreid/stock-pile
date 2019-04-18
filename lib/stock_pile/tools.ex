defmodule StockPile.Tools do
  alias Ecto.Adapters.SQL
  alias StockPile.Repo

  def sell_stock(trade_id, account_id, date) do
    query0 = Enum.join(["select * from trade_order where trade_id=", trade_id, ";"], "")
    trade_info = SQL.query(Repo, query0, []) |> map_single_row()

    query = Enum.join(["select * from historic_data where date='", date, "' and symbol='", Map.get(trade_info, "stock_symbol"), "';"], "")
    stock_info = SQL.query(Repo, query, []) |> map_single_row()

    query1 = Enum.join(["delete from trade_order where trade_id=", trade_id, ";"], "")

    q1 = SQL.query(Repo, query1, [])
    case q1 do
      {:ok, _} ->
        amount = Map.get(trade_info, "num_of_share") * Map.get(stock_info, "close_price")
        SQL.query(Repo, Enum.join(["update dealer set account_balance = account_balance + ", Integer.to_string(amount), " where account_id=", account_id, ";"], ""), [])
      _ ->
        {:error, ""}
    end
  end

  def invest_dealer(trade_order) do
    query1 = "select * from historic_data where symbol='" <> Map.get(trade_order, "stock_symbol") <> "' and date='" <> Map.get(trade_order, "date") <> "';"

    q1 = SQL.query(Repo, query1, [])
    case q1 do
      {:ok, _} ->
        q1_map = map_single_row(q1)
        IO.puts(inspect(q1_map))
        query2 = Enum.join([
        "insert into trade_order(trade_id, date, type, stock_symbol, num_of_share, price_per_share, result, account_id)
        values (", Map.get(trade_order, "trade_id"), ", '", Map.get(trade_order, "date"), "', '", Map.get(trade_order, "type"), "', '", Map.get(trade_order, "stock_symbol"), "',
        ", Map.get(trade_order, "num_of_share"), ", ", Integer.to_string(Map.get(q1_map, "close_price")), ", '", Map.get(trade_order, "result"), "', ", Map.get(trade_order, "account_id"), ");
        "], "")

        q2 = SQL.query(Repo, query2, [])
        case {q2, q1_map} do
          {{:ok, _}, q1m} ->
            num_of_share = Map.get(trade_order, "num_of_share") |> Integer.parse() |> elem(0)
            amount = -1 * num_of_share * Map.get(q1m, "close_price")
            IO.puts(inspect(amount))
            SQL.query(Repo, Enum.join(["update dealer set account_balance = account_balance + ", Integer.to_string(amount), " where account_id=", Map.get(trade_order, "account_id"), ";"], ""), [])
          _ ->
            {:error, ""}
        end
      _ ->
        {:error, ""}
    end
  end

  def fetch_orders(account_id) do
    q1 = "select * from trade_order where account_id=" <> Integer.to_string(account_id) <> ";"
    query_result = SQL.query(Repo, q1, [])
    case query_result do
        {:ok, dbo} ->
          qmap = Map.from_struct(dbo)
          IO.puts(inspect(Map.get(qmap, :rows)))
          Map.get(qmap, :rows)
    end
  end

  def lookup_stock(ticker_val) do
    q1 = "select * from stock s where s.symbol='" <> ticker_val <> "';"
    query_result1 = SQL.query(Repo, q1, [])
    q2 = "select * from historic_data h where h.symbol='" <> ticker_val <> "';"
    query_result2 = SQL.query(Repo, q2, [])
    IO.puts(inspect({map_single_row(query_result1), query_result2}))
    {map_single_row(query_result1), query_result2}
  end

  def register_broker(account) do
    query1 = Enum.join([
    "insert into account(account_id, user_name, password, account_type, status)
    values (", Map.get(account, "account_id"), ", '" , Map.get(account, "user_name") , "', '" , Map.get(account, "password") , "', 'broker', 'active');"], "")

    query2 = Enum.join(["insert into broker (account_id, first_name, last_name, address, ssn, bonus)
    values (" , Map.get(account, "account_id") , ", '" , Map.get(account, "first_name") , "', '" , Map.get(account, "last_name") , "', '" , Map.get(account, "address") , "', " , Map.get(account, "ssn") ,
    ", " , Map.get(account, "bonus") , ");
    "], "")

    q1 = SQL.query(Repo, query1, [])
    case q1 do
      {:ok, _} ->
        SQL.query(Repo, query2, [])
      _ ->
        {:error, ""}
    end
  end

  def register_dealer(account) do
    query1 = Enum.join([
    "insert into account(account_id, user_name, password, account_type, status)
    values (", Map.get(account, "account_id"), ", '" , Map.get(account, "user_name") , "', '" , Map.get(account, "password") , "', 'dealer', 'active');"], "")

    query2 = Enum.join(["insert into dealer (account_id, first_name, last_name, account_balance, address, email, tax_payer_No)
    values (" , Map.get(account, "account_id") , ", '" , Map.get(account, "first_name") , "', '" , Map.get(account, "last_name") , "', '" , Map.get(account, "address") , "', '" , Map.get(account, "email") ,
    "', " , Map.get(account, "tax_payer_No") , ");
    "], "")

    q1 = SQL.query(Repo, query1, [])
    case q1 do
      {:ok, _} ->
        SQL.query(Repo, query2, [])
      _ ->
        {:error, ""}
    end
  end

  def add_funds(amount, id) do
    _query_result = SQL.query(Repo, "update dealer set account_balance = account_balance + " <> amount <> " where account_id=" <> id <> ";", [])
    get_account_by_id(id)
  end

  def get_account_by_id(id) do
    if id != "nil" do
      query_result = SQL.query(Repo, "select * from account where account_id=" <> id <> ";", [])
      acc = map_single_row(query_result)
      if Map.get(acc, "account_type") == "dealer" do
        dealer_result = SQL.query(Repo, "select * from account a join dealer d on a.account_id = d.account_id where a.account_id=" <> id <> ";", [])
          |> map_single_row()
        IO.puts("dr: " <> inspect(dealer_result))
        dealer_result
      else
        broker_result = SQL.query(Repo, "select * from account a join broker b on a.account_id = b.account_id where a.account_id=" <> id <> ";", [])
          |> map_single_row()
        broker_result
      end
    else
      nil
    end
  end

  def auth_user(user_name, password) do
    query_result = SQL.query(Repo, "select * from account where user_name='" <> user_name <> "' and password='" <> password <> "';", [])
    acc = map_single_row(query_result)
    IO.puts("ACC" <> inspect(acc))
    if Map.get(acc, "account_type") == "dealer" do
      dealer_result = SQL.query(Repo, "select * from account a join dealer d on a.account_id = d.account_id where a.user_name='" <> user_name <> "' and a.password='" <> password <> "';", [])
        |> map_single_row()
      IO.puts("dr: " <> inspect(dealer_result))
      dealer_result
    else
      broker_result = SQL.query(Repo, "select * from account a join broker b on a.account_id = b.account_id where a.user_name='" <> user_name <> "' and a.password='" <> password <> "';", [])
        |> map_single_row()
      broker_result
    end
  end

  defp map_single_row(query_result) do
    IO.puts(inspect(query_result))
    case query_result do
      {:ok, %Mariaex.Result{} = mariaex_result} ->
        result = mariaex_result |> Map.from_struct()
        if Map.get(result, :rows) != [] do
          Enum.zip(Map.get(result, :columns), Map.get(result, :rows) |> Enum.at(0)) |> Enum.into(%{})
        else
          nil
        end
    end
  end
end
