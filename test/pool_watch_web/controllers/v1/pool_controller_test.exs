defmodule PoolWatchWeb.V1.PoolControllerTest do
  use PoolWatchWeb.ConnCase

  describe "Pool controller test" do
    test "show action", %{conn: conn} do
      pool = get_pool()

      assert %{"data" => nil} ==
        conn
        |> get(Routes.api_v1_pool_path(conn, :show, "bad-hash"))
        |> json_response(200)

      assert %{"data" => response} =
        conn
        |> get(Routes.api_v1_pool_path(conn, :show, pool.hash))
        |> json_response(200)

      assert response["id"] == pool.id

    end
  end
end
