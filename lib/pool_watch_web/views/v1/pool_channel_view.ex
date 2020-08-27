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
    %{
      id: pool_channel.id,
      is_active: pool_channel.is_active,
      channel_id: pool_channel.channel_id,
      info: pool_channel.info
    }
  end
end
