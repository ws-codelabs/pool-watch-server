defmodule PoolWatchWeb.V1.UserController do
  use PoolWatchWeb, :controller
  alias PoolWatch.Account

  action_fallback PoolWatchWeb.FallbackController

  def create(conn, %{"code" => code}) do
    with {:ok, response} <- Account.login(code) do
      conn
      |> render("session.json", %{session: response})
    end
  end
end
