defmodule Shortcut.Groups.Group do
  use Shortcut.Schema
  alias Ecto.Changeset
  alias Shortcut.Tasks.Task

  @type t :: %__MODULE__{
          id: binary(),
          title: String.t(),
          status: :empty | :incomplete | :complete,
          tasks: list(Task.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @status_values [:empty, :incomplete, :complete]

  schema "groups" do
    field :title, :string
    field :status, Ecto.Enum, values: @status_values

    has_many :tasks, Task

    timestamps()
  end

  @fields ~w(title)a

  @spec create_changeset(String.t()) :: Changeset.t()
  def create_changeset(title) do
    %__MODULE__{}
    |> cast(%{title: title}, @fields)
    |> validate_required(@fields)
    |> put_change(:status, :empty)
  end

  @spec update_status_changeset(t(), atom()) :: Changeset.t()
  def update_status_changeset(group, new_status) do
    group
    |> cast(%{status: new_status}, [:status])
  end
end
