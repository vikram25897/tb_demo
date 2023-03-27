defmodule ShortcutWeb.Router do
  use ShortcutWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ShortcutWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShortcutWeb do
    pipe_through :browser

    live "/", GroupsLive.Index
    live "/groups/:id", GroupsLive.Show
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShortcutWeb do
  #   pipe_through :api
  # end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:shortcut, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
