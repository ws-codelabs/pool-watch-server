defmodule PoolWatchWeb.V1.TokenController do
  use PoolWatchWeb, :controller
  alias PoolWatch.Account.TokenRegistry

  def create(conn, %{"email" => email}) do
    with {:ok, code} <- TokenRegistry.handle_new_user(email) do
      conn
      |> json(%{code_hash: PoolWatch.Utils.genrate_hash(code)})
    end
  end

end
