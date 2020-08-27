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

  def request(%Discord{} = discord) do
    IO.inspect discord
  end
end
