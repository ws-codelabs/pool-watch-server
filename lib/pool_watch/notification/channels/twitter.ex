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

  def get_header(%Twitter{} = twitter) do
    creds = OAuther.credentials(
      consumer_key: twitter.consumer_key,
      consumer_secret: twitter.consumer_secret,
      token: twitter.key,
      token_secret: twitter.secret
    )

    {{_, oauth_values}, _} =
      OAuther.sign("post", get_url(twitter), [], creds)
      |> OAuther.header()

    [{"Authorization", oauth_values}]

  end

  def get_url(%Twitter{content: content}) do
    content =
      content
      |> URI.encode(&URI.char_unreserved?/1)

    "https://api.twitter.com/1.1/statuses/update.json?status=#{content}"

  end
end

defimpl PoolWatch.Notification.Channels, for: PoolWatch.Notification.Channels.Twitter  do

  alias PoolWatch.Notification.Channels.Twitter

  def request(%Twitter{} = twitter) do
    case HTTPoison.post(Twitter.get_url(twitter), "", Twitter.get_header(twitter)) do
      {:ok, %HTTPoison.Response{body: body, status_code: code}} ->
        %{
          body: Jason.decode!(body),
          code: code
        }
    end
  end
end
