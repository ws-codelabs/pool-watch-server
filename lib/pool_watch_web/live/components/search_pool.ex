defmodule PoolWatchWeb.Components.SearchPool do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <form phx-submit="get_pool">
        <input type="text" name="query" placeholder="Enter Pool ID" autocomplete="off"/>
        <button type="submit" phx-disable-with="Searching...">Search</button>
      </form>
    """
  end
end
