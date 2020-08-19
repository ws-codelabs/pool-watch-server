defmodule PoolWatchWeb.V1.UserView do
  use PoolWatchWeb, :view

  alias PoolWatchWeb.V1.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("session.json", %{session: %{user_info: user, token: token}}) do
    %{data: %{ user_info: render_one(user, UserView, "user.json"), token: token}}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      profile: user.profile,
      is_verified: user.is_verified
    }
  end
end
