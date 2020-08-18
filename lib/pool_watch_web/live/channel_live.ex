defmodule PoolWatchWeb.ChannelLive do

  use PoolWatchWeb, :live_view

  @impl true
  def mount(_assigns, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div> this is channel Live </div>
    """
  end
end
