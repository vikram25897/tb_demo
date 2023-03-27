defmodule Shortcut.GroupsTest do
  use Shortcut.DataCase

  alias Shortcut.Groups

  describe "list_groups" do
    test "lists all groups" do
      group_fixture("group 1")
      group_fixture("group 2")

      assert [
               %Groups.Group{title: "group 1"},
               %Groups.Group{title: "group 2"}
             ] = Groups.list_groups()
    end
  end

  describe "create_group" do
    test "creates a group" do
      assert {:ok, %Groups.Group{title: "group 1"}} = Groups.create_group("group 1")
    end
  end
end
