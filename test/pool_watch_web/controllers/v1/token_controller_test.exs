defmodule PoolWatchWeb.V1.TokenControllerTest do
  use PoolWatchWeb.ConnCase

  describe "Token Controller Test" do
    test "create action creates token for user", %{conn: conn} do

      assert %{"data" => response} =
        conn
        |> post(Routes.api_v1_token_path(conn, :create), %{"email" => "e@e.com"})
        |> json_response(200)

      assert is_binary(response["code_hash"])

      assert %{"errors" => "INVALID_EMAIL"} ==
        conn
        |> post(Routes.api_v1_token_path(conn, :create), %{"email" => nil})
        |> json_response(422)

    end
  end
end
