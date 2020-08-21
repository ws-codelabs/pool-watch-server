defmodule PoolWatchWeb.V1.PoolController do
  use PoolWatchWeb, :controller
  alias PoolWatch.Pool
  alias PoolWatch.Pool.PoolInfo
  alias PoolWatch.Query.StakePoolQuery

  def show(conn, %{"id" => query}) do
    pool_data =
      query
      |> Pool.search_pool()
      |> check_more_pool_info()

    conn
    |> render("show.json", %{pool: pool_data})
  end

  defp check_more_pool_info(pool_info) do
    case pool_info do
      %PoolInfo{url: url, ticker: nil} when is_binary(url) ->
        attrs = StakePoolQuery.fetch_extra_pool_info(pool_info)
        {:ok, updated_pool} = Pool.update_info(pool_info, attrs)

        updated_pool

      _ ->
        pool_info
    end
  end

end
