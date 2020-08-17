defmodule PoolWatch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PoolWatch.Repo,
      # Start the Telemetry supervisor
      PoolWatchWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PoolWatch.PubSub},
      # Start the Endpoint (http/https)
      PoolWatchWeb.Endpoint
      # Start a worker by calling: PoolWatch.Worker.start_link(arg)
      # {PoolWatch.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PoolWatch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PoolWatchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
