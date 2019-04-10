defmodule StockPile.Tools do
  alias Ecto.Adapters.SQL
  alias StockPile.Repo

  def register_broker(account) do
    query1 = Enum.join([
    "insert into account(account_id, user_name, password, account_type, status)
    values (", Map.get(account, "account_id"), ", '" , Map.get(account, "user_name") , "', '" , Map.get(account, "password") , "', 'broker', 'active');"], "")

    query2 = Enum.join(["insert into broker (account_id, first_name, last_name, address, ssn, bonus)
    values (" , Map.get(account, "account_id") , ", '" , Map.get(account, "first_name") , "', '" , Map.get(account, "last_name") , "', 0, '" , Map.get(account, "address") , "', " , Map.get(account, "ssn") ,
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

    query2 = Enum.join(["insert into dealer (account_id, first_name, last_name, account_balance, address, email, tax_payer_no)
    values (" , Map.get(account, "account_id") , ", '" , Map.get(account, "first_name") , "', '" , Map.get(account, "last_name") , "', 0, '" , Map.get(account, "address") , "', '" , Map.get(account, "email") ,
    "', " , Map.get(account, "tax_payer_no") , ");
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

  def map_single_row(query_result) do
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
