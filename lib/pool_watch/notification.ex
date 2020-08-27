defmodule PoolWatch.Notification do
  alias PoolWatch.Pool.PoolInfo
  alias PoolWatch.Channel.PoolChannels
  alias PoolWatch.Channel.ChannelInfo
    @doc """

  """
  def fetch_infos(_pool_info, :default) do
    case Application.get_env(:pool_watch, :notification_settings) do
      %{send_default_notification: true, default_notification_channels: channels} ->
        channels

      _ ->
        []
    end
  end

  def fetch_infos(%PoolInfo{} = pool_info, _) do
    pool_info
    |> PoolWatch.Channel.list_pool_channel(pool_info)
    |> Enum.map(&prepare_data/1)
    |> Enum.find(&is_map/1)
  end

  def prepare_data(%PoolChannels{channel_id: c_id, info: info}) do
    case PoolWatch.Listener.ChannelCache.get_channel(c_id) do
      %ChannelInfo{name: name} ->
        %{"name" => name, "info" => info}

      _ -> nil
    end
  end

  def prepare_data(_), do: nil
end
