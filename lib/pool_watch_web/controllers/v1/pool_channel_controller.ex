defmodule PoolWatchWeb.V1.PoolChannelController do
  use PoolWatchWeb, :controller

  alias PoolWatch.Channel
  alias PoolWatch.Pool

  action_fallback PoolWatchWeb.FallbackController

  def index(conn, %{"pool_id" => pool_id}) do
    conn
    |> render("index.json", %{pool_channels: Channel.list_pool_channel(conn.assigns.current_user, pool_id)})
  end

  def create(conn, %{"user_pool_id" => u_p_id, "channel_id" => cl_id, "pool_channel" => p_channel}) do
    user_pool =
      conn.assigns.current_user
      |> Pool.get_user_pool(u_p_id)

    channel = Channel.get_channel_info(cl_id)

    with {:ok, pool_channel} <- Channel.create_pool_channel(user_pool, channel, p_channel ) do
      pool_channel = Map.put(pool_channel, :channel, channel)

      conn
      |> render("show.json", %{pool_channel: pool_channel})
    end


  end

  def update(conn, %{"id" => id, "pool_channel" => channel_attrs}) do
    pool_channel =
      conn.assigns.current_user
      |> Channel.get_pool_channel(id)

    with {:ok, updated_pool_channel} <- Channel.update_pool_channel(pool_channel, channel_attrs) do
      conn
      |> render("show.json", %{pool_channel: updated_pool_channel})
    end
  end

  def delete(conn, %{"id" => id}) do
    pool_channel =
      conn.assigns.current_user
      |> Channel.get_pool_channel(id)

    with {:ok, deleted_pool_channel} <- Channel.delete_pool_channel(pool_channel) do
      conn
      |> render("show.json", %{pool_channel: deleted_pool_channel})
    end

  end
end
