defmodule PoolWatch.Query.StakePoolQuery do
  @moduledoc """
    contains StakePool related query
  """
  alias PoolWatch.Utils
  alias PoolWatch.Pool.PoolInfo
  alias PoolWatch.Query.CommonFields

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
            #{CommonFields.stake_pool_fields}
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
        |> Task.await(50_000)
        |> format_pool_data()
        |> Enum.filter(&(is_binary(&1[:metadata_hash]) and is_binary(&1[:hash])))

      pools ++ new_pool_data
    end)

  end

  def format_pool_data(data) when is_list(data) do
    data
    |> Enum.map(&format_pool_data/1)
  end

  def format_pool_data(data) when is_map(data) do
    case Map.get(data, :inserted_at) do
      nil ->
        cast_pool_data(data)
      _ ->
        data

    end
  end

  defp cast_pool_data(data) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    %{
      fixed_cost: Utils.to_int(data["fixedCost"]),
      hash: data["hash"],
      margin: Utils.to_float(data["margin"]),
      metadata_hash: data["metadataHash"],
      pledge: Utils.to_int(data["pledge"]),
      reward_address: data["rewardAddress"],
      url: data["url"],
      inserted_at: timestamp,
      updated_at: timestamp
    }
  end

  def fetch_extra_pool_info(%PoolInfo{url: url}) do
    fetch_extra_pool_info(url)
  end

  def fetch_extra_pool_info(url) when is_binary(url) do
    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> Jason.decode()
        |> format_extra_pool_info()

      _ ->
        fetch_with_curl(url)
    end
  end

  defp fetch_with_curl(url) when is_binary(url) do
    curl_params = [
      "--connect-timeout", "5",
      "--retry", "2",
      "--retry-delay", "0",
      "--retry-max-time",  "60",
      url
    ]

    case System.cmd("curl", curl_params) do
      {body, _} ->
        Jason.decode(body)
        |> format_extra_pool_info()
    end
  end

  defp format_extra_pool_info({:ok, data}) when is_map(data) do
    %{
      name: Map.get(data, "name"),
      description: Map.get(data, "description"),
      ticker: Map.get(data, "ticker"),
      home_url: Map.get(data, "homepage")
    }
  end

  defp format_extra_pool_info(_), do: %{}
end
