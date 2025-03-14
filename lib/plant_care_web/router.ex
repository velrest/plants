defmodule PlantCareWeb.Router do
  use PlantCareWeb, :router

  use AshAuthentication.Phoenix.Router

  import AshAuthentication.Plug.Helpers

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PlantCareWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
    plug :set_actor, :user
  end

  scope "/", PlantCareWeb do
    pipe_through :browser

    ash_authentication_live_session :authenticated_routes do
      live "/plants", PlantLive.Index, :index
      live "/plants/new", PlantLive.Index, :new
      live "/plants/:id/edit", PlantLive.Index, :edit

      live "/plants/:id", PlantLive.Show, :show
      live "/plants/:id/show/edit", PlantLive.Show, :edit
      live "/plants/:id/show/add_event", PlantLive.Show, :add_event

      live "/events", EventLive.Index, :index
      live "/events/new", EventLive.Index, :new
      live "/events/:id/edit", EventLive.Index, :edit

      live "/events/:id", EventLive.Show, :show
      live "/events/:id/show/edit", EventLive.Show, :edit
      # in each liveview, add one of the following at the top of the module:
      #
      # If an authenticated user must be present:
      # on_mount {PlantCareWeb.LiveUserAuth, :live_user_required}
      #
      # If an authenticated user *may* be present:
      # on_mount {PlantCareWeb.LiveUserAuth, :live_user_optional}
      #
      # If an authenticated user must *not* be present:
      # on_mount {PlantCareWeb.LiveUserAuth, :live_no_user}
    end
  end

  scope "/", PlantCareWeb do
    pipe_through :browser

      get "/", PageController, :home

    auth_routes AuthController, PlantCare.Accounts.User, path: "/auth"
    sign_out_route AuthController

    # Remove these if you'd like to use your own authentication views
    sign_in_route register_path: "/register",
                  reset_path: "/reset",
                  auth_routes_prefix: "/auth",
                  on_mount: [{PlantCareWeb.LiveUserAuth, :live_no_user}],
                  overrides: [
                    PlantCareWeb.AuthOverrides,
                    AshAuthentication.Phoenix.Overrides.Default
                  ]

    # Remove this if you do not want to use the reset password feature
    reset_route auth_routes_prefix: "/auth",
                overrides: [
                  PlantCareWeb.AuthOverrides,
                  AshAuthentication.Phoenix.Overrides.Default
                ]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlantCareWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:plant_care, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PlantCareWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  if Application.compile_env(:plant_care, :dev_routes) do
    import AshAdmin.Router

    scope "/admin" do
      pipe_through :browser

      ash_admin "/"
    end
  end
end
