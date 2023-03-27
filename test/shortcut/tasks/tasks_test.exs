defmodule Shortcut.TasksTest do
  use Shortcut.DataCase

  alias Shortcut.Tasks
  alias Shortcut.Tasks.Task
  alias Shortcut.Groups.Group

  describe "list_tasks" do
    test "lists all tasks" do
      group = group_fixture("group 1")
      task_fixture(%{title: "task 1", group_id: group.id})
      task_fixture(%{title: "task 2", group_id: group.id})

      assert [
               %Tasks.Task{title: "task 1"},
               %Tasks.Task{title: "task 2"}
             ] = Tasks.list_tasks_in_group(group.id)
    end
  end

  describe "create_task" do
    setup [:create_group]

    test "creates a task with no dependancy", %{group: %Group{id: group_id}} do
      assert {:ok, %Tasks.Task{title: "task 1", group_id: ^group_id}} =
               Tasks.create_task(%{title: "task 1", group_id: group_id, dependency_id: nil})
    end

    test "creates a task with incomplete dependancy", %{group: %Group{id: group_id}} do
      {:ok, %Task{id: dependency_id}} =
        Tasks.create_task(%{title: "task 1", group_id: group_id, dependency_id: nil})

      assert {:ok,
              %Tasks.Task{
                title: "task 2",
                group_id: ^group_id,
                dependency_id: ^dependency_id,
                status: :locked
              }} =
               Tasks.create_task(%{
                 title: "task 2",
                 group_id: group_id,
                 dependency_id: dependency_id
               })
    end

    defp create_group(_) do
      [group: group_fixture()]
    end
  end
end
