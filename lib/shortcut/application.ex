defmodule Shortcut.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ShortcutWeb.Telemetry,
      # Start the Ecto repository
      Shortcut.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Shortcut.PubSub},
      # Start Finch
      {Finch, name: Shortcut.Finch},
      # Start the Endpoint (http/https)
      ShortcutWeb.Endpoint
      # Start a worker by calling: Shortcut.Worker.start_link(arg)
      # {Shortcut.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shortcut.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShortcutWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
