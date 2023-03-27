defmodule ShortcutWeb.Groups.Components do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias Shortcut.Groups.Group

  attr :group, :any, required: true

  def group_tile(assigns) do
    ~H"""
    <div
      class="flex flex-row hover:cursor-pointer"
      phx-click={JS.navigate("/groups/#{@group.id}")}
    >
      <Heroicons.check_circle :if={@group.status == :complete} outline class="w-6 h-6 text-green-400" />
      <Heroicons.lock_closed :if={@group.status == :incomplete} outline class="w-6 h-6 text-gray-400" />
      <Heroicons.folder_minus :if={@group.status == :empty} outline class="w-6 h-6 text-gray-400" />
      <div class="flex flex-col ml-2">
        <div class="text-sm font-medium text-gray-900">
          <%= @group.title %>
        </div>
        <div class="text-xs text-gray-500">
          <%= group_description(@group) %>
        </div>
      </div>
    </div>
    """
  end

  attr :task, :any, required: true

  def task_tile(assigns) do
    ~H"""
    <div class="flex flex-row items-center">
      <Heroicons.check_circle
        :if={@task.status == :complete}
        phx-click="mark_incomplete"
        phx-value-id={@task.id}
        outline
        class="w-6 h-6 text-green-400"
      />
      <Heroicons.lock_closed :if={@task.status == :locked} outline class="w-6 h-6 text-gray-400" />
      <Heroicons.stop
        :if={@task.status == :incomplete}
        phx-click="mark_complete"
        phx-value-id={@task.id}
        outline
        class="w-6 h-6 text-black-400"
      />

      <div class="flex flex-col ml-2">
        <div class="text-sm font-medium text-gray-900">
          <%= @task.title %>
        </div>
      </div>
    </div>
    """
  end

  defp group_description(%Group{tasks: tasks}) do
    total = length(tasks)

    completed = Enum.count(tasks, fn task -> task.status == :complete end)

    "#{completed} OF #{total} TASK#{if tasks > 1, do: "S", else: ""} COMPLETE"
  end
end
