defmodule Shortcut.Tasks.Task do
  use Shortcut.Schema
  alias Ecto.Changeset
  alias Shortcut.Groups.Group

  @type t :: %__MODULE__{
          id: binary(),
          title: String.t(),
          status: atom(),
          group: Group.t(),
          dependency: Task.t() | nil,
          dependents: [Task.t()],
          dependency_id: binary() | nil
        }

  @status_values [:incomplete, :complete, :locked]

  schema "tasks" do
    field :title, :string
    field :status, Ecto.Enum, values: @status_values
    belongs_to :group, Group
    belongs_to :dependency, __MODULE__
    has_many :dependents, __MODULE__, foreign_key: :dependency_id

    timestamps()
  end

  @fields ~w(dependency_id)a
  @required_fields ~w(title group_id status)a

  @spec create_changeset(map()) :: Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @fields ++ @required_fields)
    |> validate_required(@required_fields)
  end

  def update_status_changeset(task, status) do
    task
    |> cast(%{status: status}, [:status])
    |> validate_required([:status])
  end
end
