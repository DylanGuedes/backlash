defmodule Labyrinth.ProjectTest do
  use Labyrinth.ModelCase
  alias Labyrinth.Project
  alias Labyrinth.Setup

  @valid_attrs %{name: "niceproject", description: "its nice rly"}
  @invalid1 %{name: "a", description: ""}
  @invalid2 %{name: String.duplicate("A", 121), description: "its nice rly"}

  test "should work for valid attrs" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "shouldnt work for invalid attrs" do
    lamb = fn (item) ->
      changeset = Project.changeset(%Project{}, item)
      refute changeset.valid?
    end

    [@invalid1, @invalid2]
    |> Enum.map(lamb)
  end

  test "should ensure uniqueness on name" do
    Labyrinth.Repo.insert(Project.changeset(%Project{}, @valid_attrs))
    assert {:error, _ }=Labyrinth.Repo.insert(Project.changeset(%Project{}, @valid_attrs))
  end

  test "should ensure relationships" do
    {:ok, setup} = Labyrinth.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs))
    {:ok, project} = Labyrinth.Repo.insert(Project.changeset(%Project{}, @valid_attrs))

    proj = Repo.preload(project, :setups)
    changeset = Ecto.Changeset.change(proj) |> Ecto.Changeset.put_assoc(:setups, [setup])
    changeset = Repo.update!(changeset)
    assert changeset.setups==[setup]
  end

end
