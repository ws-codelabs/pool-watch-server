defmodule PoolWatch.Listener.ChannelCache do
  use GenServer

  alias PoolWatch.Channel
  alias Channel.ChannelInfo

  def start_link(_attrs) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_attrs) do
    {:ok, Channel.list_channel_infos()}
  end

  @impl true
  def handle_cast({:new, new_channel}, channels) do
    case new_channel do
      %ChannelInfo{} ->
        {:noreply,  [new_channel | channels]}

      _ ->
        {:noreply, channels}
    end
  end



  @impl true
  def handle_call({:fetch, channel_id}, _from, channels) do
    {:reply, Enum.find(channels, &(&1.id == channel_id)), channels}
  end

  def get_channel(channel_id) when is_binary(channel_id) do
    case GenServer.call(__MODULE__, {:fetch, channel_id}) do
      nil ->
        Channel.get_channel_info(channel_id)

      %ChannelInfo{} = channel_info ->
        channel_info
    end
  end

end
