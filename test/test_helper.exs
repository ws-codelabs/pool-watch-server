ExUnit.start()
Neuron.Config.set(url: Application.get_env(:pool_watch, :cardano_endpoint))
Ecto.Adapters.SQL.Sandbox.mode(PoolWatch.Repo, :manual)
