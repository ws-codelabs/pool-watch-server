defmodule PoolWatch.Pool.PoolSync do
  use GenServer
  alias PoolWatch.Pool
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Neuron.Config.set(url: Application.get_env(:pool_watch, :cardano_endpoint))
    Logger.info("[cardano-gql] Fetching Pools ....")
    IO.inspect Pool.sync_pools()
    {:ok, []}
  end
end
