defmodule Backlash.ProjectTest do
  use Backlash.ModelCase
  alias Backlash.Project
  alias Backlash.Setup

  @valid_attrs %{name: "niceproject", description: "its nice rly"}
  @valid_attrs2 %{name: "niceproject2", description: "its nice rly"}
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
    Backlash.Repo.insert(Project.changeset(%Project{}, @valid_attrs))
    assert {:error, _ }=Backlash.Repo.insert(Project.changeset(%Project{}, @valid_attrs))
  end

  test "should ensure relationships" do
    {:ok, setup} = Backlash.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs))
    {:ok, project} = Backlash.Repo.insert(Project.changeset(%Project{}, @valid_attrs))

    proj = Repo.preload(project, :setups)
    changeset = Ecto.Changeset.change(proj) |> Ecto.Changeset.put_assoc(:setups, [setup])
    changeset = Repo.update!(changeset)
    assert changeset.setups==[setup]
  end

  test "should successfully push setups" do
    {:ok, setup} = Backlash.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs))
    {:ok, setup2} = Backlash.Repo.insert(Setup.changeset(%Setup{}, @valid_attrs2))
    {:ok, project} = Backlash.Repo.insert(Project.changeset(%Project{}, @valid_attrs))

    Project.push_setup(project, setup)
    updt_project = Repo.get(Project, project.id) |> Repo.preload(:setups)
    assert length(updt_project.setups)==1

    project = Repo.get(Project, project.id)
    setup2 = Repo.get(Setup, setup2.id)

    Project.push_setup(project, setup2)
    updt_project = Repo.get(Project, project.id) |> Repo.preload(:setups)
    assert length(updt_project.setups)==2
  end

end
