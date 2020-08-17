defmodule PoolWatch.FactoryCase do
  alias PoolWatch.Account
  alias PoolWatch.Pool

  @user_attrs %{email: "e@e.com", is_verified: true}
  @pool_attrs %{hash: "default-pool-hash", metadata_hash: "default_metadata_hash"}

  def get_user(attrs \\ @user_attrs) do
    {:ok, user} =
      case Account.get_user({:email, attrs.email}) do
        nil ->
          Account.create_user(attrs)

        user ->
          {:ok, user}
      end

    user
  end

  def get_pool(attrs \\  @pool_attrs) do
    {:ok, pool} =
      case Pool.search_pool(attrs.hash) do
        nil ->
          Pool.create_pool(attrs)

        pool_info ->
          {:ok, pool_info}
      end

    pool
  end
end
