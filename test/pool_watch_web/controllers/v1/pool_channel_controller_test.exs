defmodule PoolWatchWeb.V1.PoolChannelControllerTest do
  use PoolWatchWeb.ConnCase

  alias PoolWatch.Channel
  alias PoolWatch.Pool

  @valid_channel %{
    "info" => %{"web_hook_url" => "https://discordapp.com/api/webhooks/api_key/channel_id"},
    "is_active" => true
  }

  @update_channel %{
    "info" => %{"web_hook_url" => "https://discordapp.com/api/webhooks/new__key/new_channel_id"},
    "is_active" => false
  }

  describe "Pool Channel Controller Test" do
    setup do
      pool = get_pool()
      {:ok, user_pools} = Pool.create_user_pools(get_user(), pool)
      channel_info = Channel.get_channel_info({:name, "Discord"})

      {:ok, %{pool: pool, u_pool: user_pools, c_info: channel_info}}

    end
    test "index action gives list of channels", %{conn: conn, c_info: channel_info, u_pool: user_pool} do
      pool = get_pool()

      assert %{"data" => []} ==
        conn
        |> setup_auth()
        |> get(Routes.api_v1_pool_channel_path(conn, :index), %{"pool_id" => pool.id})
        |> json_response(200)

      assert {:ok, user_channel} = Channel.create_pool_channel(user_pool, channel_info, @valid_channel)

      assert %{"data" => [response]} =
        conn
        |> setup_auth()
        |> get(Routes.api_v1_pool_channel_path(conn, :index), %{"pool_id" => pool.id})
        |> json_response(200)

      assert response["id"] == user_channel.id
      assert response["channel"]["id"] == channel_info.id

    end

    test "create action creates new pool_channel", %{conn: conn, c_info: channel_info, u_pool: user_pool} do
      params =%{
        "user_pool_id" => user_pool.id,
        "channel_id" => channel_info.id,
        "pool_channel" => @valid_channel
      }

      assert %{"data" => response} =
        conn
        |> setup_auth()
        |> post(Routes.api_v1_pool_channel_path(conn, :create), params)
        |> json_response(200)

      assert response["channel"]["id"] == channel_info.id
      assert response["info"] == @valid_channel["info"]
    end

    test "update action updates pool_channel", %{conn: conn, c_info: channel_info, u_pool: user_pool} do
      assert {:ok, user_channel} = Channel.create_pool_channel(user_pool, channel_info, @valid_channel)

      params = %{
        "pool_channel" => @update_channel
      }

      assert %{"data" => response} =
        conn
        |> setup_auth()
        |> put(Routes.api_v1_pool_channel_path(conn, :update, user_channel.id), params)
        |> json_response(200)

      assert response["id"] == user_channel.id
      assert response["info"] == @update_channel["info"]
      assert response["is_active"] == @update_channel["is_active"]

    end

    test "delete action deletes pool", %{conn: conn, c_info: channel_info, u_pool: user_pool} do
      assert {:ok, user_channel} = Channel.create_pool_channel(user_pool, channel_info, @valid_channel)

      assert %{"data" => response} =
        conn
        |> setup_auth()
        |> delete(Routes.api_v1_pool_channel_path(conn, :delete, user_channel.id))
        |> json_response(200)

      assert response["id"] == user_channel.id

      assert nil == Channel.get_pool_channel(get_user(), user_channel.id)

    end
  end
end
