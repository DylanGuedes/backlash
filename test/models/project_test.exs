defmodule Labyrinth.ProjectTest do
  use Labyrinth.ModelCase
  alias Labyrinth.Project

  @valid_attrs %{name: "niceproject", description: "its nice rly"}
  @invalid_attrs %{}

  test "should work for valid attrs" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "shouldnt work for invalid attrs" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "validations should work" do
  end
end
