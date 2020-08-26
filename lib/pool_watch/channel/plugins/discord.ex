defmodule PoolWatch.Channel.Plugins.Discord do
  alias PoolWatch.Utils
  alias PoolWatch.Channel.Plugins.Discord

  defmodule Fields do
    defstruct [:name, :value, :inline]

    def new(fields) do
      fields
      |> Enum.map(&(Utils.struct_from_map(&1, as: %__MODULE__{})))
    end
  end

  defmodule Embed do
    defstruct [
      :title,
      :description,
      :url,
      :color,
      :timestamp,
      :author,
      fields: Fields.__struct__
    ]

    def new(data) do
      %Embed{
        title: Map.get(data, "title"),
        description: Map.get(data, "description"),
        url: Map.get(data, "url"),
        color: Map.get(data, "color"),
        timestamp: Map.get(data, "timestamp"),
        author: Map.get(data, "author"),
        fields: Fields.new(Map.get(data, "fields", []))
      }
    end

  end

  defstruct [:content, api_url: String, embed: Embed.__struct__]

  defp new(data) do
    %Discord{
      content: Map.get(data, "content"),
      api_url: Map.get(data, "api_url"),
      embed: Embed.new(Map.get(data, "embed", %{}))
    }
  end

  def cast(data) do
    data
    |> Utils.to_string_map()
    |> new()
  end

  def inject_api_url(%Discord{} = discord, api_url) do
    Map.put(discord, :api_url, api_url)
  end

end

defimpl PoolWatch.Channel.Plugins, for: PoolWatch.Channel.Plugins.Discord   do
  alias PoolWatch.Channel.Plugins.Discord

  def request(%Discord{} = discord) do
    IO.inspect discord
  end
end
