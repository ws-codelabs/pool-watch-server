defmodule PoolWatchWeb.V1.UserController do
  use PoolWatchWeb, :controller
  alias PoolWatch.Account

  action_fallback PoolWatchWeb.FallbackController

  def index(conn, _) do
    conn
    |> render("show.json", %{user: conn.assigns.current_user})
  end

  def create(conn, %{"code" => code}) do
    with {:ok, response} <- Account.login(code) do
      conn
      |> render("session.json", %{session: response})
    end
  end
end
