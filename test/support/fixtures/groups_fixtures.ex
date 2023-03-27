defmodule Shortcut.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shortcut.Groups` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(title \\ nil) do
    title = title || "some title #{Enum.random(1..1000)}}}"
    {:ok, group} = Shortcut.Groups.create_group(title)
    group
  end
end
