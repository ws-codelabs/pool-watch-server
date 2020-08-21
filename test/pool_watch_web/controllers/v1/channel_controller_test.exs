defmodule PoolWatchWeb.V1.ChannelControllerTest do
  use PoolWatchWeb.ConnCase

  describe "channel Controller test" do
    test "index action", %{conn: conn} do
      assert %{"data" => [response | _]} =
        conn
        |> setup_auth()
        |> get(Routes.api_v1_channel_path(conn, :index))
        |> json_response(200)

      assert response["name"] == "Discord"

    end
  end
end
