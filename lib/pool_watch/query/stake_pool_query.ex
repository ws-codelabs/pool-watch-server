defmodule PoolWatch.Query.StakePoolQuery do
  @moduledoc """
    contains StakePool related query
  """
  alias PoolWatch.Utils

  def get_stakepool_aggregate_data() do
    query = """
      {
        stakePools_aggregate{
          aggregate{
            count
          }
        }
      }
    """
    case Neuron.query(query) do
      {:ok, %Neuron.Response{body: body}} ->
        count =
          body
          |> get_in(["data", "stakePools_aggregate", "aggregate", "count"])
          |> String.to_integer()

        %{total_pools: count}

      _ ->
        %{total_pools: nil}
    end
  end

  def get_total_stake_pools() do
    case get_stakepool_aggregate_data() do
      %{total_pools: count} ->
        count
    end
  end

  def list_stake_Pool(offset \\ 0) do
    query =
      """
        {
          stakePools(offset: #{offset}){
            hash,
            url,
            metadataHash,
            pledge,
            margin,
            fixedCost,
            rewardAddress,
            fixedCost
          }
        }
      """

    case Neuron.query(query) do
      {:ok, %Neuron.Response{body: %{"data" => %{"stakePools" => stake_pools}}}} ->
        format_pool_data(stake_pools)

      _ ->
        []
    end
  end

  def list_all_stake_pool(previous_pools \\ 0) when is_integer(previous_pools) do

    steps =
      get_total_stake_pools()
      |> Kernel.-(previous_pools)
      |> Kernel./(100)
      |> Float.ceil()
      |> Utils.to_int()

    awaits =
      for offset <-  0..(steps-1) do
        Task.async(fn -> list_stake_Pool((offset * 100) + previous_pools) end)
      end

    Enum.reduce(awaits, [], fn batch, pools ->
      new_pool_data =
        batch
        |> Task.await()
        |> format_pool_data()

      pools ++ new_pool_data
    end)

  end

  def format_pool_data(data) when is_list(data) do
    data
    |> Enum.map(&format_pool_data/1)
  end

  def format_pool_data(data) when is_map(data) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    %{
        description: nil,
        fixed_cost: Utils.to_int(data["fixedCost"]),
        hash: data["hash"],
        home_url: nil,
        margin: Utils.to_float(data["margin"]),
        metadata_hash: data["metadataHash"],
        pledge: Utils.to_int(data["pledge"]),
        reward_address: data["rewardAddress"],
        ticker: nil,
        url: nil,
        inserted_at: timestamp,
        updated_at: timestamp
    }
  end
end
