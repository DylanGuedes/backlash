defmodule Backlash.ProjectTest do
  use Backlash.ModelCase

  import Backlash.Factory

  alias Backlash.Project
  alias Backlash.Setup
  alias Backlash.Repo
  alias Backlash.User

  @invalid1 %{name: "a", description: ""}
  @invalid2 %{name: String.duplicate("A", 121), description: "its nice rly"}

  test "should work for valid attrs" do
    user = insert(:user)
    changeset = Project.changeset(Ecto.build_assoc(user, :created_projects, params_for(:project)), %{})
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
    insert(:project)
    changeset = Project.changeset(%Project{}, params_for(:project))
    assert {:error, _ } = Repo.insert(changeset)
  end

  test "should ensure multiple relationships" do
    project = insert(:project)
    target = insert(:target)
    {:ok, setup} = target |> Ecto.build_assoc(:setups, params_for(:setup)) |> Repo.insert
    {:ok, setup2} = target |> Ecto.build_assoc(:setups, params_for(:setup, %{name: "otherproject"})) |> Repo.insert

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
    project = insert(:project)
    target = insert(:target)
    {:ok, setup} = target |> Ecto.build_assoc(:setups, params_for(:setup)) |> Repo.insert
    {:ok, setup2} = target |> Ecto.build_assoc(:setups, params_for(:setup, %{name: "otherproject"})) |> Repo.insert
    Project.associate_with_setup(project, setup)
    Project.associate_with_setup(project, setup2)
    setup = Repo.get(Setup, setup.id)
    setup2 = Repo.get(Setup, setup2.id)
    project = Repo.get(Project, project.id) |> Repo.preload(:setups)
    assert project.setups==[setup, setup2]
  end

  test "total_setups should count correctly how many setups the project have" do
    project = insert(:project)
    stp = insert(:setup)
    Project.associate_with_setup(project, stp)
    project = Repo.get(Project, project.id)
    assert Project.total_setups(project.id)==1
  end
end
