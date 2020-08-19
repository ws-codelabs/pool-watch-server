defmodule PoolWatchWeb.V1.PoolView do
  use PoolWatchWeb, :view

  alias PoolWatchWeb.V1.PoolView

  def render("index.json", %{pools: pools}) do
    %{data: render_many(pools, PoolView, "pools.json")}
  end

  def render("show.json", %{pool: pools}) do
    %{data: render_one(pools, PoolView, "pool.json")}
  end

  def render("pool.json", %{pool: pools}) do
    %{
      id: pools.id,
      description: pools.description,
      fixed_cost: pools.fixed_cost,
      hash: pools.hash,
      home_url: pools.home_url,
      margin: pools.margin,
      metadata_hash: pools.metadata_hash,
      pledge: pools.pledge,
      reward_address: pools.reward_address,
      ticker: pools.ticker,
      url: pools.url
    }
  end

end
