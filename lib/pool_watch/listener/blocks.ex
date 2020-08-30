defmodule PoolWatch.Listener.Blocks do
  use GenServer

  alias PoolWatch.Blockchain.Blocks
  alias PoolWatch.Query.BlocksQuery
  alias PoolWatch.Pool

  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @default_interval 5000

  @settings Application.get_env(:pool_watch, :app_settings)

  @impl true
  def init(_) do
    if Map.get(@settings, "watch_block") do
      monitor_blocks(1000)
    end

    {:ok, %{block_info: nil, is_active: true}}
  end

  @impl true
  def handle_info(:check_block, state) do
    new_block = BlocksQuery.get_latest_block()
    monitor_blocks()
    if is_new_block?(new_block, Map.get(state, :block_info)) do
      # handle new block
      spawn(fn -> handle_new_block(new_block) end)

      { :noreply,
        state
        |> Map.put(:block_info, new_block)
      }

    else
      {:noreply, state}
    end
  end

  defp handle_new_block(%Blocks{slot_leader: %{"stake_pool" => nil}}), do: nil
  defp handle_new_block(%Blocks{slot_leader: %{"stake_pool" => stake_pool}} = blocks) do

    pool_info =
      Map.get(stake_pool, "metadata_hash")
      |> Pool.get_pool_detail()

    Logger.info(" Found New Block")

    if Map.get(@settings, "send_default_notification") do
      Logger.info("Sending Notification to Default Channels")

      Blocks.handle_block(pool_info, blocks, :default)
    end

    Logger.info("Sending Notification for #{pool_info.ticker}")
    Blocks.handle_block(pool_info, blocks, :pool)
  end

  defp monitor_blocks(interval \\ @default_interval) do
    Process.send_after(self(), :check_block, interval)
  end

  def is_new_block?(%Blocks{number: new_number}, %Blocks{number: current_number}) do
    new_number > current_number
  end

  def is_new_block?(_, _), do: false

end
