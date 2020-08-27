defmodule PoolWatch.NotificationTest do
  use PoolWatch.DataCase
  alias PoolWatch.Notification

  @default_notification Application.get_env(:pool_watch, :notification_settings)

  describe "Notification Test" do
    test "fetch_infos gives list of channel infos" do
      assert default_notification_info = Notification.fetch_infos(get_pool(), :default)
      assert default_notification_info == @default_notification.default_notification_channels
    end

    test "fetch_info gives pools channel list" do

    end
  end
end
