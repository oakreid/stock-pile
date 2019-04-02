defmodule StockPile.Tools do
  alias Ecto.Adapters.SQL
  alias StockPile.Repo

  def get_account_by_id(id) do
    SQL.query(Repo, "select * from account where account_id=$1::integer", [id])
    |> elem(1) |> Map.get(:rows) |> Enum.at(1)
  end

  def get_account_by_user_name(user_name) do
    SQL.query(Repo, "select * from account where user_name='$1'", [user_name])
    |> elem(1) |> Map.get(:rows) |> Enum.at(1)
  end
end
