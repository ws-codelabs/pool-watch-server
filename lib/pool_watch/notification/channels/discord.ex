defmodule PoolWatch.Notification.Channels.Discord do
  alias PoolWatch.Notification.Channels.Discord

  defstruct [:data, api_url: String]

  def new(data, api_url) do
    %Discord{
      data: data,
      api_url: api_url,
    }
  end

end

defimpl PoolWatch.Notification.Channels, for: PoolWatch.Notification.Channels.Discord do
  alias PoolWatch.Notification.Channels.Discord

  def request(%Discord{api_url: api_url, data: data}) do

    case HTTPoison.post(api_url, Jason.encode!(data), [{"Content-Type", "application/json"}]) do
      {:ok, %HTTPoison.Response{body: body, status_code: code}} ->
        %{body: body, code: code}
    end
  end
end
