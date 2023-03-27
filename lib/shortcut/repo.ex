defmodule Shortcut.Repo do
  use Ecto.Repo,
    otp_app: :shortcut,
    adapter: Ecto.Adapters.Postgres
end
