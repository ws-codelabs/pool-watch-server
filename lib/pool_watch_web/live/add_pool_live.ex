defmodule PoolWatchWeb.AddPoolLive do
  use PoolWatchWeb, :live_view

  alias PoolWatch.Pool
  alias PoolWatchWeb.Components.SearchPool
  alias PoolWatchWeb.Components.UserForm


  @impl true
  def mount(_assigns, _session, socket) do
    {:ok, assign(socket, selected_pool: nil, current_user: nil)}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <%= if get_component(assigns) == :redirect do %>
        <div>
          <h4> Setting up Channels.... </h4>
        </div>

      <% else %>
        <%= live_component(@socket, get_component(assigns)) %>
      <% end %>
    """
  end

  @impl true
  def handle_event("get_pool", %{"query" => query}, socket) do
    case Pool.search_pool(query) do
      nil ->
        {:noreply,
          socket
          |> put_flash(:error, "No Stake Pool Found")
        }

      pool_info ->
        {:noreply,
          socket
          |> assign(selected_pool: pool_info)
        }
    end
  end

  defp get_component(%{selected_pool: s_pool, current_user: c_user}) do
    cond do
      is_nil(s_pool) ->
        SearchPool

      is_nil(c_user) ->
        UserForm

      true ->
        :redirect
    end
  end
end
