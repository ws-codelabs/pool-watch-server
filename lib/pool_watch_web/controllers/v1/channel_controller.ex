defmodule PoolWatchWeb.V1.ChannelController do
  use PoolWatchWeb, :controller

  alias PoolWatch.Channel

  def index(conn, _) do
    conn
    |> render("index.json", %{channels: Channel.list_channel_infos()})
  end
end
