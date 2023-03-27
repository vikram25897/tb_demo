defmodule Shortcut.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias Shortcut.Repo

  alias Shortcut.Groups.Group
  alias Shortcut.Groups.Queries

  @spec list_groups :: list(Group.t())
  def list_groups() do
    Repo.all(Queries.list_query())
  end

  @spec get_group(binary()) :: {:ok, Group.t()} | {:error, :group_not_found}
  def get_group(id) do
    id
    |> Queries.get_group_query()
    |> Repo.one()
    |> case do
      nil -> {:error, :group_not_found}
      group -> {:ok, group}
    end
  end

  @spec create_group(String.t()) :: {:ok, Group.t()} | {:error, Ecto.Changeset.t()}
  def create_group(title) do
    title
    |> Group.create_changeset()
    |> Repo.insert()
  end
end
