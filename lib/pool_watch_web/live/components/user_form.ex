defmodule PoolWatchWeb.Components.UserForm do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <form phx-submit="user_auth">
        <input type="email" name="query" placeholder="Enter Valid Email" autocomplete="off"/>
        <button type="submit" phx-disable-with="Searching...">Send Code</button>
      </form>
    """
  end
end
