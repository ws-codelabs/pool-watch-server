defmodule PoolWatch.FactoryCase do
  alias PoolWatch.Account
  alias PoolWatch.Pool

  @user_attrs %{email: "e@e.com", is_verified: true}
  @pool_attrs %{
    hash: "default-pool-hash",
    metadata_hash: "default_metadata_hash",
    ticker: "TEST_POOL_WATCH",
    name: "Test pool Watch"

  }

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

  def setup_auth(conn, email \\ "e@e.com") do
    {:ok, code} = PoolWatch.Account.TokenRegistry.handle_new_user(email)
    {:ok, %{token: token}} = Account.login(code)

    conn
    |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")
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
