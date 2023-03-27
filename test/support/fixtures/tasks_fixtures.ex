defmodule Shortcut.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shortcut.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        status: :incomplete,
        title: "some title",
        group_id: Shortcut.GroupsFixtures.group_fixture().id,
        dependency_id: nil
      })
      |> Shortcut.Tasks.create_task()

    task
  end
end
