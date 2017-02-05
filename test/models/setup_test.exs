defmodule Backlash.SetupTest do
  use Backlash.ModelCase

  import Backlash.Factory

  alias Backlash.Setup
  alias Backlash.Project
  alias Backlash.Repo
  alias Backlash.Target
  alias Backlash.ProjectSetup

  @valid_attrs %{name: "some content"}

  test "changeset with valid attributes" do
    insert(:project)
    target = insert(:target)

    changeset = Ecto.build_assoc(target, :setups, params_for(:setup))
    assert {:ok, _} = Repo.insert(changeset)
  end

  test "changeset with invalid attributes" do
    changeset = Setup.changeset(%Setup{}, %{})
    refute changeset.valid?
  end

  test "should ensure uniqueness" do
    setup = insert(:setup)
    assert {:error, _}=Backlash.Repo.insert(Setup.changeset(%Setup{}, %{name: setup.name}))
  end

  test "should ensure relationships" do
    project = insert(:project)
    target = insert(:target)

    changeset = Ecto.build_assoc(target, :setups, @valid_attrs)
    {:ok, setup} = Repo.insert(changeset)
    changeset = setup |> Repo.preload(:projects) |> Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:projects, [project])
    {:ok, stp} = Repo.update(changeset)
    assert stp.projects==[project]
  end

  test "used projects function" do
    setup = insert(:setup) |> Repo.preload(:projects)
    project = insert(:project, params_for(:project))
    assert Repo.all(Setup.used_projects(setup))==[]

    Repo.insert ProjectSetup.relate(project.id, setup.id)
    setup = Repo.get(Setup, setup.id) |> Repo.preload(:projects)
    assert Repo.all(Setup.used_projects(setup))==[project]
    assert Repo.all(Setup.used_projects(setup))==setup.projects

    project1 = insert(:project, params_for(:project, %{name: "anotherone1"}))
    project2 = insert(:project, params_for(:project, %{name: "anotherone2"}))
    Repo.insert ProjectSetup.relate(project1.id, setup.id)
    Repo.insert ProjectSetup.relate(project2.id, setup.id)
    project3 = insert(:project, params_for(:project, %{name: "anotherone3"}))

    setup = Repo.get(Setup, setup.id) |> Repo.preload(:projects)
    assert Repo.all(Setup.used_projects(setup))==setup.projects
    assert Repo.all(Setup.used_projects(setup))==[project, project1, project2]
  end

  test "unused projects" do
    setup = insert(:setup) |> Repo.preload(:projects)
    project = insert(:project, params_for(:project, %{name: "anotherone"}))
    project1 = insert(:project, params_for(:project, %{name: "anotherone1"}))
    project2 = insert(:project, params_for(:project, %{name: "anotherone2"}))
    project3 = insert(:project, params_for(:project, %{name: "anotherone3"}))
    assert Repo.all(Setup.unused_projects(setup))==[project, project1, project2, project3]
    Repo.insert ProjectSetup.relate(project.id, setup.id)
    assert Repo.all(Setup.unused_projects(setup))==[project1, project2, project3]
  end
end
