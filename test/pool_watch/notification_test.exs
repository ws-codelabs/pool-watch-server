defmodule PoolWatch.NotificationTest do
  use PoolWatch.DataCase

  alias PoolWatch.Notification
  alias PoolWatch.Channel
  alias PoolWatch.Pool


  @default_notification Application.get_env(:pool_watch, :notification_settings)

  @twitter %{
    "info" =>  %{"key" => "t_key", "secret" => "s_key", "username" => "u1"},
    "is_active" => true
  }

  @discord %{
    "info" => %{"web_hook_url" => "https://discordapp.com/api/webhooks/api_key/channel_id"},
    "is_active" => true
  }

  describe "Notification Test" do
    test "fetch_infos gives list of channel infos" do
      assert default_notification_info = Notification.fetch_infos(get_pool(), :default)
      assert default_notification_info == @default_notification.default_notification_channels
    end

    test "fetch_info gives pools channel list" do
      {:ok, u_pools} = Pool.create_user_pools(get_user(), get_pool())

      c_discord = Channel.get_channel_info({:name, "Discord"})
      c_twitter = Channel.get_channel_info({:name, "Twitter"})

      assert {:ok, u_d_channel} = Channel.create_pool_channel(u_pools, c_discord, @discord)
      assert {:ok, u_t_channel} = Channel.create_pool_channel(u_pools, c_twitter, @twitter)

      assert [d_info, t_info] = Notification.fetch_infos(get_pool(), :stake_pool)
      assert d_info["info"] == u_d_channel.info
      assert t_info["info"] == u_t_channel.info
    end
  end
end
