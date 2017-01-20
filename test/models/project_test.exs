defmodule Backlash.ProjectTest do
  use Backlash.ModelCase

  alias Backlash.Project
  alias Backlash.Setup
  alias Backlash.Target

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
    {:ok, project} = Repo.insert(Project.changeset(%Project{}, @valid_attrs))
    {:ok, target} = Repo.insert(Target.changeset(%Target{}, @valid_attrs))
    {:ok, setup} = target |> Ecto.build_assoc(:setups, @valid_attrs) |> Repo.insert
    setup = setup |> Repo.preload(:projects)

    changeset = setup |> Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:projects, [project])
    {:ok, _} = Repo.update(changeset)

    setup = Repo.get(Setup, setup.id)

    project = Project |> Repo.get(project.id) |> Repo.preload(:setups)
    assert project.setups==[setup]
  end

  test "should ensure multiple relationships" do
    {:ok, project} = Repo.insert(Project.changeset(%Project{}, @valid_attrs))
    {:ok, target} = Repo.insert(Target.changeset(%Target{}, @valid_attrs))
    {:ok, setup} = target |> Ecto.build_assoc(:setups, @valid_attrs) |> Repo.insert
    {:ok, setup2} = target |> Ecto.build_assoc(:setups, @valid_attrs2) |> Repo.insert

    setup = setup |> Repo.preload(:projects)
    changeset = setup |> Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:projects, [project])
    {:ok, _} = Repo.update(changeset)

    setup2 = setup2 |> Repo.preload(:projects)
    changeset = setup2 |> Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:projects, [project])
    {:ok, _} = Repo.update(changeset)

    setup = Repo.get(Setup, setup.id)
    setup2 = Repo.get(Setup, setup2.id)

    project = Project |> Repo.get(project.id) |> Repo.preload(:setups)
    assert project.setups==[setup, setup2]
  end

  test "associate with setup" do
    {:ok, project} = Repo.insert(Project.changeset(%Project{}, @valid_attrs))
    {:ok, target} = Repo.insert(Target.changeset(%Target{}, @valid_attrs))
    {:ok, setup} = target |> Ecto.build_assoc(:setups, @valid_attrs) |> Repo.insert
    {:ok, setup2} = target |> Ecto.build_assoc(:setups, @valid_attrs2) |> Repo.insert
    Project.associate_with_setup(project, setup)
    Project.associate_with_setup(project, setup2)
    setup = Repo.get(Setup, setup.id)
    setup2 = Repo.get(Setup, setup2.id)
    project = Repo.get(Project, project.id) |> Repo.preload(:setups)
    assert project.setups==[setup, setup2]
  end

end
