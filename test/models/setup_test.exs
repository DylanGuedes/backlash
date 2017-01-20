defmodule Backlash.SetupTest do
  use Backlash.ModelCase

  alias Backlash.Setup
  alias Backlash.Project
  alias Backlash.Repo
  alias Backlash.Target

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    {:ok, project} = Repo.insert(Project.changeset(%Project{}, @valid_attrs))
    {:ok, target} = Repo.insert(Target.changeset(%Target{}, @valid_attrs))

    changeset = Ecto.build_assoc(target, :setups, @valid_attrs)
    assert {:ok, _} = Repo.insert(changeset)
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
    {:ok, project} = Repo.insert(Project.changeset(%Project{}, @valid_attrs))
    {:ok, target} = Repo.insert(Target.changeset(%Target{}, @valid_attrs))

    changeset = Ecto.build_assoc(target, :setups, @valid_attrs)
    {:ok, setup} = Repo.insert(changeset)
    changeset = setup |> Repo.preload(:projects) |> Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:projects, [project])
    {:ok, stp} = Repo.update(changeset)
    assert stp.projects==[project]
  end

end
