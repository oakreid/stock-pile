defmodule StockPile.Tools do
  alias Ecto.Adapters.SQL
  alias StockPile.Repo

  def register_broker(account) do
      # TODO
      nil
  end

  def register_dealer(account) do
      # TODO
      nil
  end

  def add_funds(amount, id) do
    _query_result = SQL.query(Repo, "update account set account_balance = account_balance + " <> amount <> " where account_id=" <> id <> ";", [])
    get_account_by_id(id)
  end

  def get_account_by_id(id) do
    if id != "nil" do
      query_result = SQL.query(Repo, "select * from account where account_id=" <> id <> ";", [])
      map_single_row(query_result)
    else
      nil
    end
  end

  def auth_user(user_name, password) do
    password_hash = Argon2.hash_pwd_salt(password)
    query_result = SQL.query(Repo, "select * from account where user_name='" <> user_name <> "' and password='" <> password <> "';", [])
    map_single_row(query_result)
  end

  def map_single_row(query_result) do
    case query_result do
      {:ok, %Mariaex.Result{} = mariaex_result} ->
        result = mariaex_result |> Map.from_struct()
        IO.puts(inspect(Map.get(result, :rows)))
        if Map.get(result, :rows) != [] do
          Enum.zip(Map.get(result, :columns), Map.get(result, :rows) |> Enum.at(0)) |> Enum.into(%{})
        else
          nil
        end
    end
  end
end
