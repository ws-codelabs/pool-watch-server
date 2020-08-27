defmodule PoolWatch.Query.BlocksQueryTest do
  use PoolWatch.DataCase
  alias PoolWatch.Query.BlocksQuery

  test "get_latest_block gives latest block info" do
    assert is_map(BlocksQuery.get_latest_block())
  end

  test "get_block_after gives block data right after the block number" do
    assert block_data = BlocksQuery.get_block_after(460000)
    assert block_data.number == 460001
  end

end
