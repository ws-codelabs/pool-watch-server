defmodule PoolWatchWeb.V1.UserPoolView do
  use PoolWatchWeb, :view

  alias __MODULE__, as: UserPoolView
  alias PoolWatchWeb.V1.UserView

  def render("index.json", %{user_pools: user_pools}) do
    %{data: render_many(user_pools, UserPoolView, "user_pool.json")}
  end

  def render("show.json", %{session: session, user_pool: user_pool}) do
    %{
      data: %{
        user_pool: render_one(user_pool, UserPoolView, "user_pool.json"),
        session: %{
          token: session.token,
          user_info: render_one(session.user_info, UserView, "user.json")
        }
      }
    }
  end

  def render("show.json", %{user_pool: user_pool}) do
    %{data: render_one(user_pool, UserPoolView, "user_pool.json")}
  end


  def render("user_pool.json", %{user_pool: user_pool}) do
    pool =
      if Ecto.assoc_loaded?(user_pool.pool) do
        render_one(user_pool.pool, PoolWatchWeb.V1.PoolView, "pool.json")
      else
        nil
      end

    %{
      id: user_pool.id,
      is_active: user_pool.is_active,
      priv_key: user_pool.priv_key,
      pub_key: user_pool.pub_key,
      pool: pool
    }
  end
end
