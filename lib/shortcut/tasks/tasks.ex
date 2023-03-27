defmodule Shortcut.Tasks do
  @moduledoc """
  The Tasks context.
  """
  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Shortcut.Repo

  alias Shortcut.Tasks.Task
  alias Shortcut.Tasks.Queries
  alias Shortcut.Groups
  alias Shortcut.Groups.Group
  alias Shortcut.Groups.Queries, as: GroupQueries

  @spec list_tasks_in_group(binary()) :: list(Task.t())
  def list_tasks_in_group(group_id) do
    group_id
    |> Queries.list_tasks_in_group_query()
    |> Repo.all()
  end

  def update_task_status(task_id, status) do
    Multi.new()
    |> Multi.one(:task, Queries.get_task_query_for_update(task_id))
    |> Multi.update(:updated_task, &Task.update_status_changeset(&1.task, status))
    |> Multi.update_all(
      :update_dependents,
      fn _ -> Queries.update_dependents_query(task_id, status) end,
      []
    )
    |> Multi.one(:group, &GroupQueries.get_group_for_update_query(&1.task.group_id))
    |> Multi.update(:updated_group, &maybe_update_group_status/1)
    |> Repo.transaction()
    |> case do
      {:ok, %{updated_task: task}} -> {:ok, task}
      {:error, :task, _, _} -> {:error, :task_not_found}
      {:error, :group, _, _} -> {:error, :group_not_found}
    end
  end

  @spec create_task(map()) ::
          {:ok, Task.t()} | {:error, :group_not_found} | {:error, Ecto.Changeset.t()}
  def create_task(%{group_id: group_id, dependency_id: dependency_id} = params) do
    Multi.new()
    |> Multi.one(:group, GroupQueries.get_group_for_update_query(group_id))
    |> maybe_fetch_dependency(dependency_id)
    |> Multi.insert(:task, fn
      %{dependency: %{status: status}} ->
        if status in [:incomplete, :locked] do
          Task.create_changeset(Map.put(params, :status, :locked))
        else
          Task.create_changeset(Map.put(params, :status, :incomplete))
        end

      _ ->
        Task.create_changeset(Map.put(params, :status, :incomplete))
    end)
    |> Multi.update(:updated_group, &Groups.Group.update_status_changeset(&1.group, :incomplete))
    |> Repo.transaction()
    |> case do
      {:ok, %{task: task}} -> {:ok, task}
      {:error, :group, _, _} -> {:error, :group_not_found}
      {:error, :task, changeset, _} -> {:error, changeset}
    end
  end

  defp maybe_fetch_dependency(multi, nil), do: multi

  defp maybe_fetch_dependency(multi, dependency_id) do
    Multi.one(multi, :dependency, Queries.get_task_query(dependency_id))
  end

  defp maybe_update_group_status(%{group: %Group{tasks: tasks} = group}) do
    if Enum.all?(tasks, &(&1.status == :complete)) do
      Groups.Group.update_status_changeset(group, :complete)
    else
      Groups.Group.update_status_changeset(group, :incomplete)
    end
  end
end
