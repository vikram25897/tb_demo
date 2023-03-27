defmodule Shortcut.Tasks.Queries do
  import Ecto.Query, warn: false

  alias Ecto.Query
  alias Shortcut.Tasks.Task

  @spec list_tasks_in_group_query(binary()) :: Query.t()
  def list_tasks_in_group_query(group_id) do
    from t in Task, where: t.group_id == ^group_id, order_by: [asc: t.inserted_at]
  end

  @spec get_task_query(binary()) :: Query.t()
  def get_task_query(task_id) do
    from t in Task, where: t.id == ^task_id
  end

  @spec get_task_query_for_update(binary()) :: Query.t()
  def get_task_query_for_update(task_id) do
    from t in Task, where: t.id == ^task_id, lock: "FOR UPDATE", preload: [:dependents]
  end

  @spec update_dependents_query(binary(), atom()) :: Query.t()
  def update_dependents_query(task_id, status) do
    new_status = if status == :complete, do: :incomplete, else: :locked
    from t in Task,
      where: t.dependency_id == ^task_id,
      update: [set: [status: ^new_status]]
  end
end
