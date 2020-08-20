defmodule PoolWatchWeb.V1.UserPoolController do
  use  PoolWatchWeb, :controller

  alias PoolWatch.Pool

  action_fallback PoolWatchWeb.FallbackController

  def index(conn, _) do

    conn
    |> render("index.json", %{user_pools: Pool.list_user_pools(conn.assigns.current_user)})
  end

  def create(conn, %{"pool_id" => pool_id}) do
    pool_detail = Pool.get_info(pool_id)
    user_info = conn.assigns.current_user

    with {:ok, user_pool} <- Pool.create_user_pools(user_info, pool_detail) do
      user_pool = Map.put(user_pool, :pool, pool_detail)

      conn
      |> render("show.json", %{user_pool: user_pool})
    end
  end

  def guest_create(conn, %{"pool_id" => pool_id, "code" => code}) do
    with {:ok, %{user_info: user} = session} <- PoolWatch.Account.login(code) do
      pool_detail = Pool.get_info(pool_id)

      case Pool.create_user_pools(user, pool_detail) do
        {:ok, user_pool} ->
          user_pool = Map.put(user_pool, :pool, pool_detail)

          conn
          |> render("show.json", %{session: session, user_pool: user_pool})

        {:error, reason} ->
          {:error, reason}
      end
    end
  end

  def update(conn, %{"id" => id, "user_pool" => %{"is_active" => is_active}}) do
    user_pool =
      conn.assigns.current_user
      |> Pool.get_user_pool(id)

    with {:ok, updated_pool} <- Pool.change_user_pool_status(user_pool, is_active) do
      conn
      |> render("show.json", %{user_pool: updated_pool})
    end
  end

  # TODO: Delete can be only possible by  Code Verification
  def delete(conn, %{"id" => id}) do
    user_pool =
      conn.assigns.current_user
      |> Pool.get_user_pool(id)

    with {:ok, deleted_pool} <- Pool.delete_user_pools(user_pool) do
      conn
      |> render("show.json", %{user_pool: deleted_pool})
    end
  end

end
