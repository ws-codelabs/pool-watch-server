defmodule PoolWatch.PoolChannelTtest do
  use PoolWatch.DataCase

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

  @invalid_channel %{
    "info" => nil,
    "is_active" => nil
  }

  @valid_twitter %{
    info: %{"key" => "t_key", "secret" => "s_key", "username" => "u1"},
    is_active: true
  }

  def user_pool_fixture(attrs \\ @valid_channel) do
    channel_info = Channel.get_channel_info({:name, "Discord"})
    {:ok, user_pools} = Pool.create_user_pools(get_user(), get_pool())
    Channel.create_pool_channel(user_pools, channel_info, attrs)
  end

  describe "Pool channel Test" do
    test "create_pool_channel creates pool channel" do
      {:ok, user_pools} = Pool.create_user_pools(get_user(), get_pool())
      channel_info = Channel.get_channel_info({:name, "Discord"})

      assert {:ok, user_channel} = Channel.create_pool_channel(user_pools, channel_info, @valid_channel)
      assert user_channel.info == @valid_channel["info"]
      assert is_binary(user_channel.id)

      assert {:error, %Ecto.Changeset{}} = Channel.create_pool_channel(user_pools, channel_info, @invalid_channel)

      assert {:error, :INVALID_USER_POOL} == Channel.create_pool_channel(nil, channel_info, %{})
      assert {:error, :INVALID_CHANNEL} == Channel.create_pool_channel(user_pools, nil, %{})
    end

    test "list_pool_channel gives list of pool channel" do
      pool = get_pool()
      user = get_user()

      assert [] == Channel.list_pool_channel(user, pool.id)

      assert {:ok, user_channel} = user_pool_fixture(@valid_channel)

      assert [found_u_channel] = Channel.list_pool_channel(user, pool.id)
      assert found_u_channel.id == user_channel.id

      assert [found_u_channel] = Channel.list_pool_channel(user, [pool.id])
      assert found_u_channel.id == user_channel.id

    end

    test "list_pool_channel also gives list of valid channel for notification" do
      {:ok, u_pools} = Pool.create_user_pools(get_user(), get_pool())
      c_discord = Channel.get_channel_info({:name, "Discord"})
      c_twitter = Channel.get_channel_info({:name, "Twitter"})

      assert {:ok, u_d_channel} = Channel.create_pool_channel(u_pools, c_discord, @valid_channel)
      assert {:ok, u_t_channel} = Channel.create_pool_channel(u_pools, c_twitter, @valid_twitter)

      assert [u_d1, u_t1] = Channel.list_pool_channel(get_pool())
      assert u_d_channel.id == u_d1.id
      assert u_t_channel.id == u_t1.id

      assert {:ok, _} = Channel.update_pool_channel(u_d_channel, %{is_active: false})
      assert [u_t1] == Channel.list_pool_channel(get_pool())

      assert Pool.update_user_pool(u_pools, %{is_active: false})
      assert [] == Channel.list_pool_channel(get_pool())
    end

    test "update_pool_channel updates pool channel" do
      assert {:ok, pool_channel} = user_pool_fixture(@valid_channel)
      assert {:ok, updated_channel} = Channel.update_pool_channel(pool_channel, @update_channel)
      assert pool_channel.id == updated_channel.id
      assert updated_channel.info == @update_channel["info"]

      assert {:error, :INVALID_POOL_CHANNEL} == Channel.update_pool_channel(nil, @update_channel)
    end

    test "delete_pool_channel" do
      assert {:ok, pool_channel} = user_pool_fixture(@valid_channel)
      assert {:ok, d_pool_channel} = Channel.delete_pool_channel(pool_channel)
      assert d_pool_channel.id == pool_channel.id

      assert {:error, :INVALID_POOL_CHANNEL} == Channel.delete_pool_channel(nil)

      assert nil == Channel.get_pool_channel(get_user(), pool_channel.id)
    end
  end
end
