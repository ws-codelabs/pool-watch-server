defmodule PoolWatchWeb.V1.ChannelView do
  use PoolWatchWeb, :view

  alias __MODULE__, as: ChannelView

  def render("index.json", %{channels: channels}) do
    %{data: render_many(channels, ChannelView, "channel.json")}
  end

  def render("show.json", %{channel: channel}) do
    %{data: render_one(channel, ChannelView, "channel.json")}
  end

  def render("channel.json", %{channel: channel}) do
    %{
      id: channel.id,
      logo: channel.logo,
      name: channel.name,
      is_active: channel.is_active,
      inputs: channel.inputs
    }
  end
end
