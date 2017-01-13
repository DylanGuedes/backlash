defmodule Labyrinth.SetupTest do
  use Labyrinth.ModelCase

  alias Labyrinth.Setup
  alias Labyrinth.Project

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Setup.changeset(%Setup{}, @valid_attrs)
    assert changeset.valid?
    assert {:ok, _}=Labyrinth.Repo.insert(changeset)
  end

  test "changeset with invalid attributes" do
    changeset = Setup.changeset(%Setup{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "should ensure uniqueness" do
    Labyrinth.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs))
    assert {:error, _}=Labyrinth.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs))
  end

  test "should ensure relationships" do
    {:ok, setup} = Labyrinth.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs))
    {:ok, project} = Labyrinth.Repo.insert(Project.changeset(%Project{}, @valid_attrs))

    setup = Repo.preload(setup, :projects)
    changeset = Ecto.Changeset.change(setup) |> Ecto.Changeset.put_assoc(:projects, [project])
    changeset = Repo.update!(changeset)
    assert changeset.projects==[project]
  end
end
