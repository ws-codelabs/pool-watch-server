defmodule PoolWatchWeb.V1.PoolController do
  use PoolWatchWeb, :controller
  alias PoolWatch.Pool

  def search(conn, %{"query" => query}) do
    conn
    |> render("show.json", %{pool: Pool.get_pool_detail(query)})
  end
end
