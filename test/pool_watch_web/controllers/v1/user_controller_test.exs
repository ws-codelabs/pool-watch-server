defmodule PoolWatchWeb.V1.UserControllerTest do
  use PoolWatchWeb.ConnCase

  describe "User controller Test" do
    test "Login action with valid code gives user with token", %{conn: conn} do
      assert {:ok, code} = PoolWatch.Account.TokenRegistry.handle_new_user("e@e.com")
      assert %{"data" => response} =
        conn
        |> post(Routes.api_v1_user_path(conn, :create), %{"code" => code})
        |> json_response(200)

      assert is_binary(response["token"])
      assert response["user_info"]["email"] == "e@e.com"
      assert response["user_info"]["is_verified"] == true

      assert %{"errors" => "INVALID_CODE"} ==
        conn
        |> post(Routes.api_v1_user_path(conn, :create), %{"code" => "BAD--CODE"})
        |> json_response(422)

    end
  end
end
