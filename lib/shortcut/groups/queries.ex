defmodule Shortcut.Groups.Queries do
  import Ecto.Query, warn: false

  alias Ecto.Query
  alias Shortcut.Groups.Group
  alias Shortcut.Tasks.Task

  @spec list_query :: Query.t()
  def list_query do
    from g in Group, preload: :tasks
  end

  @spec get_group_for_update_query(any) :: Query.t()
  def get_group_for_update_query(group_id) do
    from g in Group, where: g.id == ^group_id, lock: "FOR UPDATE", preload: :tasks
  end

  @spec get_group_query(any) :: Query.t()
  def get_group_query(group_id) do
    tasks_query = from t in Task, order_by: [asc: t.inserted_at]
    from g in Group, where: g.id == ^group_id, preload: [tasks: ^tasks_query]
  end
end
