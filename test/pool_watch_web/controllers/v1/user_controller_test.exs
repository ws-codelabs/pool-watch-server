defmodule PoolWatchWeb.V1.UserControllerTest do
  use PoolWatchWeb.ConnCase

  describe "User controller Test" do
    test "Login action with valid code gives user with token", %{conn: conn} do
      assert {:ok, code} = PoolWatch.Account.TokenRegistry.handle_new_user("e@e.com")
      assert %{"data" => response} =
        conn
        |> post(Routes.api_v1_user_path(conn, :create), %{"code" => code})
        |> json_response(200)

      assert is_binary(response["session"]["token"])
      assert response["session"]["user_info"]["email"] == "e@e.com"
      assert response["session"]["user_info"]["is_verified"] == true

      assert %{"errors" => "INVALID_CODE"} ==
        conn
        |> post(Routes.api_v1_user_path(conn, :create), %{"code" => "BAD--CODE"})
        |> json_response(422)

    end

    test "index action gives current LoggedIn user", %{conn: conn} do
      assert %{"errors" => "INVALID_TOKEN"} =
        conn
        |> get(Routes.api_v1_user_path(conn, :index))
        |> json_response(422)

      assert %{"data" => response} =
        conn
        |> setup_auth("a@a.com")
        |> get(Routes.api_v1_user_path(conn, :index))
        |> json_response(200)

      assert response["email"] == "a@a.com"

    end
  end
end
