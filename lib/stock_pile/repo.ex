defmodule StockPile.Repo do
  use Ecto.Repo,
    otp_app: :stock_pile,
    adapter: Ecto.Adapters.MySQL
end
