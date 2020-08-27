defmodule PoolWatch.Notification.Channels.Twitter do
  @keys Application.get_env(:pool_watch, :twitter)

  alias __MODULE__, as: Twitter

  defstruct [
    consumer_secret: String,
    consumer_key: String,
    key: String,
    secret: String,
    content: String
  ]

  def new(data) do
    %Twitter{
      consumer_secret: Map.get(data, "consumer_secret") || @keys.consumer_key,
      consumer_key: Map.get(data, "consumer_key") || @keys.consumer_secret,
      key: Map.get(data, "key"),
      secret: Map.get(data, "secret"),
      content: Map.get(data, "content")
    }
  end

end
