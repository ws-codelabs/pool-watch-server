defmodule PoolWatchWeb.V1.UserPoolControllerTest do
  use PoolWatchWeb.ConnCase

  alias PoolWatch.Pool

  describe "user_pool controller" do
    test "index route gives list of Pools", %{conn: conn} do
      assert {:ok, u_pool} = Pool.create_user_pools(get_user(), get_pool())

      assert %{"data" => [response]} =
        conn
        |> setup_auth()
        |> get(Routes.api_v1_user_pool_path(conn, :index))
        |> json_response(200)

      assert response["id"] == u_pool.id
      assert response["pool"]["id"] == u_pool.pool_id
    end

    test "create actions creates new user_pool", %{conn: conn} do
      assert pool = get_pool()

      assert %{"data" => response} =
        conn
        |> setup_auth()
        |> post(Routes.api_v1_user_pool_path(conn, :create), %{"pool_id" => pool.id})
        |> json_response(200)

      assert is_binary(response["id"])
      assert is_binary(response["priv_key"])
      assert is_binary(response["pub_key"])

      assert response["pool"]["id"] == pool.id

      assert %{"errors" => "INVALID_POOL"} ==
        conn
        |> setup_auth()
        |> post(Routes.api_v1_user_pool_path(conn, :create), %{"pool_id" => Ecto.UUID.autogenerate()})
        |> json_response(422)
    end

    test "guest_create action creates new pool and user", %{conn: conn} do
      assert pool = get_pool()
      {:ok, code} = PoolWatch.Account.TokenRegistry.handle_new_user("e@e.com")

      assert %{"data" => response} =
        conn
        |> post(Routes.api_v1_user_pool_path(conn, :guest_create), %{"pool_id" => pool.id, "code" => code})
        |> json_response(200)

      assert response["session"]["user_info"]["email"] == "e@e.com"
      assert is_binary(response["session"]["token"])
      assert is_binary(response["user_pool"]["id"])
      assert is_binary(response["user_pool"]["priv_key"])
      assert is_binary(response["user_pool"]["pub_key"])

      assert response["user_pool"]["pool"]["id"] == pool.id

      assert %{"errors" => "INVALID_CODE"} ==
        conn
        |> post(Routes.api_v1_user_pool_path(conn, :guest_create), %{"pool_id" => pool.id, "code" => "bad-code"})
        |> json_response(422)

    end

    test "update action update pool info", %{conn: conn} do
      assert {:ok, u_pool} = Pool.create_user_pools(get_user(), get_pool())

      valid_params = %{
        "user_pool" => %{"is_active" => false}
      }

      assert %{"data" => response} =
        conn
        |> setup_auth()
        |> put(Routes.api_v1_user_pool_path(conn, :update, u_pool.id), valid_params)
        |> json_response(200)

      assert response["id"] == u_pool.id
      assert response["is_active"] == false

      assert %{"errors" => "INVALID_USER_POOL"} =
        conn
        |> setup_auth()
        |> put(Routes.api_v1_user_pool_path(conn, :update, Ecto.UUID.autogenerate()), valid_params)
        |> json_response(422)

    end

    test "delete action deletes pool info", %{conn: conn} do
      assert {:ok, u_pool} = Pool.create_user_pools(get_user(), get_pool())

      assert %{"data" => response} =
        conn
        |> setup_auth()
        |> delete(Routes.api_v1_user_pool_path(conn, :update, u_pool.id))
        |> json_response(200)

      assert response["id"] == u_pool.id
      assert Pool.get_user_pool(get_user(), u_pool.id) == nil

      assert %{"errors" => "INVALID_USER_POOL"} =
        conn
        |> setup_auth()
        |> delete(Routes.api_v1_user_pool_path(conn, :update, Ecto.UUID.autogenerate()))
        |> json_response(422)

    end
  end
end
