defmodule ShortcutWeb.GroupsLive.Show do
  use ShortcutWeb, :live_view

  import ShortcutWeb.CoreComponents
  import ShortcutWeb.Groups.Components

  def mount(%{"id" => id}, _session, socket) do
    case Shortcut.Groups.get_group(id) do
      {:ok, group} ->
        {:ok,
         assign(socket,
           group: group,
           show_create_dialog: false,
           form: to_form(%{"title" => "", "dependency_id" => nil})
         )}

      _ ->
        socket = socket |> put_flash(:error, "Group not found") |> redirect(to: ~p"/")
        {:ok, socket}
    end
  end

  def handle_event("toggle_create_task", _params, socket) do
    {:noreply,
     assign(socket,
       show_create_dialog: not socket.assigns.show_create_dialog,
       form: to_form(%{"title" => ""})
     )}
  end

  def handle_event("mark_complete", %{"id" => id}, socket) do
    with {:ok, _} <- Shortcut.Tasks.update_task_status(id, :complete),
         {:ok, group} <- Shortcut.Groups.get_group(socket.assigns.group.id) do
      {:noreply, assign(socket, group: group)}
    else
      {:error, error} ->
        socket = socket |> put_flash(:error, Phoenix.Naming.humanize(error))
        {:noreply, socket}
    end
  end

  def handle_event("mark_incomplete", %{"id" => id}, socket) do
    with {:ok, _} <- Shortcut.Tasks.update_task_status(id, :incomplete),
         {:ok, group} <- Shortcut.Groups.get_group(socket.assigns.group.id) do
      {:noreply, assign(socket, group: group)}
    else
      {:error, error} ->
        socket = socket |> put_flash(:error, Phoenix.Naming.humanize(error))
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"title" => title, "dependency_id" => dependency_id}, socket) do
    {:noreply,
     assign(socket, form: to_form(%{"title" => title, "dependency_id" => dependency_id}))}
  end

  def handle_event("save", %{"dependency_id" => dependency_id, "title" => title}, socket) do
    dependency_id =
      case String.trim(dependency_id) do
        "" -> nil
        id -> id
      end

    with {:ok, _} <-
           Shortcut.Tasks.create_task(%{
             title: title,
             group_id: socket.assigns.group.id,
             dependency_id: dependency_id
           }),
         {:ok, group} <- Shortcut.Groups.get_group(socket.assigns.group.id) do
      socket =
        socket
        |> assign(
          group: group,
          show_create_dialog: false,
          form: to_form(%{"title" => "", "dependency_id" => nil})
        )
        |> put_flash(:info, "Task created")

      {:noreply, socket}
    else
      {:error, changeset} ->
        socket =
          socket
          |> assign(form: to_form(changeset))
          |> assign(show_create_dialog: false)
          |> put_flash(:error, changeset.errors)

        {:noreply, socket}
    end
  end
end
