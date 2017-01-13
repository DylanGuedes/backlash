defmodule Backlash.SetupTest do
  use Backlash.ModelCase

  alias Backlash.Setup
  alias Backlash.Project

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Setup.changeset(%Setup{}, @valid_attrs)
    assert changeset.valid?
    assert {:ok, _}=Backlash.Repo.insert(changeset)
  end

  test "changeset with invalid attributes" do
    changeset = Setup.changeset(%Setup{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "should ensure uniqueness" do
    Backlash.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs))
    assert {:error, _}=Backlash.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs))
  end

  test "should ensure relationships" do
    {:ok, setup} = Backlash.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs))
    {:ok, project} = Backlash.Repo.insert(Project.changeset(%Project{}, @valid_attrs))

    setup = Repo.preload(setup, :projects)
    changeset = Ecto.Changeset.change(setup) |> Ecto.Changeset.put_assoc(:projects, [project])
    changeset = Repo.update!(changeset)
    assert changeset.projects==[project]
  end

end
