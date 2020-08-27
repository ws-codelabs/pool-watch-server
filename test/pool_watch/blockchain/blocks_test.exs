defmodule PoolWatch.Blockchain.BlocksTest do
  use PoolWatch.DataCase

  alias PoolWatch.Blockchain.Blocks
  alias PoolWatch.Channel
  alias PoolWatch.Pool

  @twitter %{
    "info" =>  %{"key" => "t_key", "secret" => "s_key", "username" => "u1"},
    "is_active" => true
  }

  @discord %{
    "info" => %{"web_hook_url" => "https://discordapp.com/api/webhooks/api_key/channel_id"},
    "is_active" => true
  }

  # alias PoolWatch.Notification.Channels.Discord

  @default_block %PoolWatch.Blockchain.Blocks{
    epoch_no: 213,
    fees: 924414,
    forged_at: "2020-08-26T13:52:42Z",
    number: 4609190,
    op_cert: "452ff31b02a1c2d21c981c56fade107a0c5f8ecf7c89c992d39797344adb558e",
    size: 1764,
    slot_in_epoch: 230871,
    slot_leader: %{
      "description" => "ShelleyGenesis-61261a95b7613ee6",
      "hash" => "61261a95b7613ee6bf2067dad77b70349729b0c50d57bc1cf30de0db4a1e73a8",
      "stake_pool" => nil
    },
    slot_no: 6883671,
    transactions_count: "4",
    vrf_key: "9c1ba7decef73b79a3acc4c054168b5ab2ebd7dec397b5b57335bcf43f016a4c"
  }

  describe "Blocks Actions Test" do
    test "handle_block/3 with default action gives list of notification_channels" do
      assert [twitter, discord] = Blocks.handle_block(get_pool(), @default_block, :default)
      assert is_binary(discord.api_url)
      assert is_binary(get_in(discord.data, ["content"]))

      assert is_binary(twitter.consumer_key)
      assert is_binary(twitter.consumer_secret)
      assert is_binary(twitter.content)
      assert is_binary(twitter.key)
      assert is_binary(twitter.secret)
    end

    test "handle_block/3 also gives user_pool_channels" do
      {:ok, u_pools} = Pool.create_user_pools(get_user(), get_pool())

      c_discord = Channel.get_channel_info({:name, "Discord"})
      c_twitter = Channel.get_channel_info({:name, "Twitter"})

      assert {:ok, u_d_channel} = Channel.create_pool_channel(u_pools, c_discord, @discord)
      assert {:ok, u_t_channel} = Channel.create_pool_channel(u_pools, c_twitter, @twitter)

      assert [discord, twitter] = Blocks.handle_block(get_pool(), @default_block, :pool)

      assert discord.api_url == @discord["info"]["web_hook_url"]
      assert is_binary(twitter.consumer_key)
      assert is_binary(twitter.consumer_secret)

      assert twitter.key == @twitter["info"]["key"]
      assert twitter.secret == @twitter["info"]["secret"]

    end
  end

end
