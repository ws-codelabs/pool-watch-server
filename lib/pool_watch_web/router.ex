defmodule PoolWatchWeb.Router do
  use PoolWatchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PoolWatchWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :normal_auth do
    plug PoolWatchWeb.Plugs.Auth
  end


  scope "/", PoolWatchWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", PoolWatchWeb.V1, as: :api_v1 do
    pipe_through :api

    get "/pools", PoolController, :search
    resources "/user", UserController, only: [:create, :update]
    resources "/token", TokenController, only: [:create]
    post "/guest/pools/", UserPoolController, :guest_create

  end

  scope "/api/v1", PoolWatchWeb.V1, as: :api_v1 do
    pipe_through [:api, :normal_auth]

    resources "/user", UserController, except: [:create, :new, :edit, :update]
    resources "/user_pools", UserPoolController, except: [:new, :edit, :show]
    resources "/channel", ChannelController, only: [:index]
    resources "/pool_channel", PoolChannelController, except: [:new, :edit, :show]

  end



  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    forward "/sent_emails", Bamboo.SentEmailViewerPlug

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PoolWatchWeb.Telemetry
    end
  end
end
