defmodule PoolWatchWeb.V1.PoolController do
  use PoolWatchWeb, :controller
  alias PoolWatch.Pool

  def show(conn, %{"id" => query}) do
    conn
    |> render("show.json", %{pool: Pool.search_pool(query)})
  end
end
