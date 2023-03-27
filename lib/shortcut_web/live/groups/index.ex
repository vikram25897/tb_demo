defmodule ShortcutWeb.GroupsLive.Index do
  use ShortcutWeb, :live_view

  import ShortcutWeb.CoreComponents
  import ShortcutWeb.Groups.Components
  alias Shortcut.Groups

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       groups: Shortcut.Groups.list_groups(),
       form: to_form(%{"title" => ""}),
       show_create_dialog: false
     )}
  end

  def handle_event("toggle_create_group", _params, socket) do
    {:noreply,
     assign(socket,
       show_create_dialog: not socket.assigns.show_create_dialog,
       form: to_form(%{"title" => ""})
     )}
  end

  def handle_event("validate", %{"title" => title}, socket) do
    {:noreply, assign(socket, form: to_form(%{"title" => title}))}
  end

  def handle_event("save", %{"title" => title}, socket) do
    case Shortcut.Groups.create_group(title) do
      {:ok, _} ->
        {:noreply,
         assign(socket,
           groups: Groups.list_groups(),
           show_create_dialog: false,
           form: to_form(%{"title" => ""})
         )}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(:error, changeset.errors)
          |> assign(form: to_form(changeset))
          |> assign(show_create_dialog: false)

        {:noreply, socket}
    end
  end
end
