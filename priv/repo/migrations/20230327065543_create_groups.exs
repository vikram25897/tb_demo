defmodule Shortcut.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :status, :string

      timestamps()
    end

    create unique_index(:groups, :title)
  end
end
