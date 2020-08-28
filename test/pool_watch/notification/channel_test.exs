defmodule PoolWatch.Notification.ChannelsTest do
  use PoolWatch.DataCase
  alias PoolWatch.Notification
  alias PoolWatch.Notification.Channels.Twitter
  #alias PoolWatch.Notification.Channels.Discord

  test "Twitter notification" do
    assert response =
      Notification.fetch_infos(get_pool(), :default)
      |> Enum.find(&(&1["name"] == "Twitter"))
      |> Map.get("info")
      |> PoolWatch.Utils.struct_from_map(as: %Twitter{})

    IO.inspect response

  end
end
