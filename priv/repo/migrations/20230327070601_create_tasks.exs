defmodule Shortcut.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :status, :string
      add :group_id, references(:groups, on_delete: :delete_all, type: :binary_id)
      add :dependency_id, references(:tasks, on_delete: :nilify_all, type: :binary_id)
      timestamps()
    end

    create index(:tasks, [:group_id])
    create index(:tasks, [:dependency_id])
  end
end
