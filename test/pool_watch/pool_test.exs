defmodule PoolWatch.PoolTest do
  use PoolWatch.DataCase

  alias PoolWatch.Pool

  describe "pool_infos" do
    alias PoolWatch.Pool.PoolInfo
    alias PoolWatch.Query.StakePoolQuery

    @valid_attrs %{description: "some description", fixed_cost: 42, hash: "some hash", home_url: "some home_url", margin: 120.5, metadata_hash: "some metadata_hash", pledge: 42, reward_address: "some reward_address", ticker: "some ticker", url: "some url"}
    @update_attrs %{description: "some updated description", fixed_cost: 43, hash: "some updated hash", home_url: "some updated home_url", margin: 456.7, metadata_hash: "some updated metadata_hash", pledge: 43, reward_address: "some updated reward_address", ticker: "some updated ticker", url: "some updated url"}
    @invalid_attrs %{description: nil, fixed_cost: nil, hash: nil, home_url: nil, margin: nil, metadata_hash: nil, pledge: nil, reward_address: nil, ticker: nil, url: nil}

    def info_fixture(attrs \\ %{}) do
      {:ok, info} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pool.create_pool()

      info
    end

    test "list_pool_infos/0 returns all pool_infos" do
      info = info_fixture()
      assert Pool.list_pool_infos() == [info]
    end

    test "insert_all_pool/1 creates multiple Pool" do
      total_count = StakePoolQuery.get_total_stake_pools()

      StakePoolQuery.list_stake_Pool(total_count - 1)
      |> Pool.insert_all_pool()

      assert [pool_data] = Pool.list_pool_infos()
      assert is_map(pool_data)

    end

    test "search_pool/1 gives pool detail" do
      info = info_fixture()
      assert nil == Pool.search_pool("BAD---HASH")
      assert info == Pool.search_pool(info.hash)
      assert info == Pool.search_pool(info.metadata_hash)
    end

    test "get_info/1 returns the info with given id" do
      info = info_fixture()
      assert Pool.get_info(info.id) == info
    end

    test "create_pool/1 with valid data creates a info" do
      assert {:ok, %PoolInfo{} = info} = Pool.create_pool(@valid_attrs)
      assert info.description == "some description"
      assert info.fixed_cost == 42
      assert info.hash == "some hash"
      assert info.home_url == "some home_url"
      assert info.margin == 120.5
      assert info.metadata_hash == "some metadata_hash"
      assert info.pledge == 42
      assert info.reward_address == "some reward_address"
      assert info.ticker == "some ticker"
      assert info.url == "some url"
    end

    test "create_pool/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pool.create_pool(@invalid_attrs)
    end

    test "update_info/2 with valid data updates the info" do
      info = info_fixture()
      assert {:ok, %PoolInfo{} = info} = Pool.update_info(info, @update_attrs)
      assert info.description == "some updated description"
      assert info.fixed_cost == 43
      assert info.hash == "some updated hash"
      assert info.home_url == "some updated home_url"
      assert info.margin == 456.7
      assert info.metadata_hash == "some updated metadata_hash"
      assert info.pledge == 43
      assert info.reward_address == "some updated reward_address"
      assert info.ticker == "some updated ticker"
      assert info.url == "some updated url"
    end

    test "update_info/2 with invalid data returns error changeset" do
      info = info_fixture()
      assert {:error, %Ecto.Changeset{}} = Pool.update_info(info, @invalid_attrs)
      assert info == Pool.get_info(info.id)
    end

    test "delete_info/1 deletes the info" do
      info = info_fixture()
      assert {:ok, %PoolInfo{}} = Pool.delete_info(info)
      assert_raise Ecto.NoResultsError, fn -> Pool.get_info(info.id) end
    end

    test "change_info/1 returns a info changeset" do
      info = info_fixture()
      assert %Ecto.Changeset{} = Pool.change_info(info)
    end
  end

  describe "user_pool test" do
    alias PoolWatch.Pool.UserPools
    test "create_user_pools creates pool for user" do
      assert {:ok, %UserPools{} = u_pool} = Pool.create_user_pools(get_user(), get_pool())
      assert is_binary(u_pool.priv_key)
      assert is_binary(u_pool.pub_key)

      assert {:error, :INVALID_USER} == Pool.create_user_pools(nil, get_pool())
      assert {:error, :INVALID_POOL} == Pool.create_user_pools(get_user(), nil)
      assert {:error, :USER_NOT_VERIFIED} == Pool.create_user_pools(get_user(%{email: "e@2.com"}), nil)

    end

    test "user_pools/1 gives list of user pools" do
      assert [] == Pool.list_user_pools(get_user())

      assert pool_info = get_pool()
      assert {:ok, %UserPools{} = u_pool} = Pool.create_user_pools(get_user(), pool_info)

      assert [user_pool] = Pool.list_user_pools(get_user())
      assert user_pool.id == u_pool.id
      assert user_pool.pool == pool_info
    end

    test "get_user_pool/2 gives detail of pool" do
      assert pool_info = get_pool()
      assert user = get_user()
      assert {:ok, %UserPools{} = u_pool} = Pool.create_user_pools(get_user(), pool_info)
      assert u_pool == Pool.get_user_pool(user, u_pool.id)
      assert nil == Pool.get_user_pool(nil, u_pool.id)
      assert nil == Pool.get_user_pool(user, nil)
    end

    test "change_user_pool_status changes user_pool status" do
      assert pool_info = get_pool()
      assert user = get_user()
      assert {:ok, %UserPools{} = u_pool} = Pool.create_user_pools(get_user(), pool_info)

      assert {:ok, %UserPools{}} = Pool.change_user_pool_status(u_pool, false)
      assert user_pool = Pool.get_user_pool(user, u_pool.id)
      assert user_pool.id == u_pool.id
      assert user_pool.is_active == false

      assert {:error, :INVALID_USER_POOL} == Pool.change_user_pool_status(nil, false)
    end

    test "delete_user_pools/1 deletes User Pool" do
      assert pool_info = get_pool()
      assert user = get_user()
      assert {:ok, %UserPools{} = u_pool} = Pool.create_user_pools(get_user(), pool_info)
      assert {:ok, %UserPools{}} = Pool.delete_user_pools(u_pool)

      assert nil == Pool.get_user_pool(user, u_pool.id)

      assert {:error, :INVALID_USER_POOL} == Pool.delete_user_pools(nil)
    end
  end
end
