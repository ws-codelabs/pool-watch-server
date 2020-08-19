defmodule PoolWatchWeb.V1.TokenController do
  use PoolWatchWeb, :controller

  alias PoolWatch.Account.TokenRegistry

  action_fallback PoolWatchWeb.FallbackController

  def create(conn, %{"email" => email}) do
    with {:ok, code} <- TokenRegistry.handle_new_user(email) do
      conn
      |> json(%{data: %{code_hash: PoolWatch.Utils.genrate_hash(code)}})
    end
  end

end
