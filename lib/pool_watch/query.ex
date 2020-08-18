defmodule PoolWatch.Query do
  Neuron.Config.set(url: Application.get_env(:pool_watch, :cardano_endpoint))

end
