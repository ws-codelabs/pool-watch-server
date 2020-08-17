defmodule PoolWatch.Repo do
  use Ecto.Repo,
    otp_app: :pool_watch,
    adapter: Ecto.Adapters.Postgres
end
