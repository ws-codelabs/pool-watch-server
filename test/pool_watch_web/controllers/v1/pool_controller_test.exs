defmodule PoolWatchWeb.V1.PoolControllerTest do
  use PoolWatchWeb.ConnCase

  describe "Pool controller test" do
    test "search action", %{conn: conn} do
      pool = get_pool()

      assert %{"data" => nil} ==
        conn
        |> get(Routes.api_v1_pool_path(conn, :search), %{query: "bad-hash"})
        |> json_response(200)

      assert %{"data" => response} =
        conn
        |> get(Routes.api_v1_pool_path(conn, :search), %{query: pool.hash})
        |> json_response(200)

      assert response["id"] == pool.id

    end
  end
end
