defmodule Backlash.TargetTest do
  use Backlash.ModelCase

  alias Backlash.Setup
  alias Backlash.Target
  alias Backlash.Repo

  @valid_attrs %{name: "some content"}
  @valid_attrs2 %{name: "some zz content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Target.changeset(%Target{}, @valid_attrs)
    assert changeset.valid?
    assert {:ok, _}=Backlash.Repo.insert(changeset)
  end

  test "changeset with invalid attributes" do
    changeset = Target.changeset(%Target{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "should ensure uniqueness" do
    Backlash.Repo.insert(Target.changeset(%Target{}, @valid_attrs))
    assert {:error, _}=Backlash.Repo.insert(Target.changeset(%Target{}, @valid_attrs))
  end

  test "should ensure relationships" do
    {:ok, target} = Backlash.Repo.insert(Target.changeset(%Target{}, @valid_attrs))
    changeset = Ecto.build_assoc(target, :setups, @valid_attrs)
    {:ok, setup} = Backlash.Repo.insert(changeset)

    target = Repo.preload(target, :setups)
    setup = Repo.get(Setup, setup.id)

    assert target.setups==[setup]
  end

  test "should ensure multiple relationships" do
    {:ok, target} = Backlash.Repo.insert(Target.changeset(%Target{}, @valid_attrs))
    changeset = Ecto.build_assoc(target, :setups, @valid_attrs)
    {:ok, setup} = Repo.insert(changeset)
    changeset = Ecto.build_assoc(target, :setups, @valid_attrs2)
    {:ok, setup2} = Repo.insert(changeset)

    setup = Repo.get(Setup, setup.id)
    setup2 = Repo.get(Setup, setup2.id)
    tgt = Target |> Repo.get(target.id) |> Repo.preload(:setups)

    assert tgt.setups==[setup,setup2]
  end

  test "link_to_target correctly linking" do
    {:ok, target} = Backlash.Repo.insert(Target.changeset(%Target{}, @valid_attrs))
    changeset = Ecto.build_assoc(target, :setups, @valid_attrs)
    {:ok, setup} = Backlash.Repo.insert(changeset)
    changeset = Ecto.build_assoc(target, :setups, @valid_attrs2)
    {:ok, setup2} = Backlash.Repo.insert(changeset)

    setup = Repo.get(Setup, setup.id)
    setup2 = Repo.get(Setup, setup2.id)

    target = Target |> Repo.get(target.id) |> Repo.preload(:setups)
    assert target.setups==[setup,setup2]
  end

end
