defmodule PoolWatchWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  alias PoolWatch.Account.Guardian
  alias PoolWatch.Account.User

  def init(opts), do: opts
  def call(conn, opts) do
    role = Keyword.get(opts, :user_role, "NORMAL")
    conn
    |> get_token()
    |> Guardian.fetch_user_from_token()
    |> handle_response(conn, role)
  end

  defp handle_response({:ok, %User{role: role} = user}, conn, o_role) when role == o_role do
    conn
    |> assign(:current_user, user)
  end

  defp handle_response({:ok, %User{}}, conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: "INVALID_ACCESS"})
    |> halt()
  end

  defp handle_response(_, conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: "INVALID_TOKEN"})
    |> halt()
  end


  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        token



      _ -> nil
    end
  end

end
