defmodule PoolWatch.Listener.Blocks do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    IO.inspect Mix.env()

    {:ok, %{block_info: %{}, is_active: true}}
  end

  # def watch_block(%block_info: block_info) do

  # end
end
