defmodule PoolWatch.StakePoolQueryTest do
  use PoolWatch.DataCase

  alias PoolWatch.Query.StakePoolQuery
  alias PoolWatch.Pool.PoolInfo

  test "fetch_extra_pool_info/1 gives detail about pool" do
    assert response = StakePoolQuery.fetch_extra_pool_info(%PoolInfo{url: "https://data.pooltool.io/md/7736838c-e7bb-44eb-a133-18c952bb50bb"})
    assert is_binary(response.ticker)

  end
end
