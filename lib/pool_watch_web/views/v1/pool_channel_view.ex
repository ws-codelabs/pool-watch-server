defmodule PoolWatchWeb.V1.PoolChannelView do
  use PoolWatchWeb, :view

  alias __MODULE__, as: PoolChannelView

  def render("index.json", %{pool_channels: pool_channels}) do
    %{data: render_many(pool_channels, PoolChannelView, "pool_channel.json")}
  end

  def render("show.json", %{pool_channel: pool_channel}) do
    %{data: render_one(pool_channel, PoolChannelView, "pool_channel.json")}
  end


  def render("pool_channel.json", %{pool_channel: pool_channel}) do
    channel =
      if Ecto.assoc_loaded?(pool_channel.channel) do
        render_one(pool_channel.channel, PoolWatchWeb.V1.ChannelView, "channel.json")
      else
        nil
      end

    %{
      id: pool_channel.id,
      is_active: pool_channel.is_active,
      channel: channel,
      info: pool_channel.info
    }
  end
end
