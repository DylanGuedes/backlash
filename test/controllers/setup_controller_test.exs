defmodule Backlash.SetupControllerTest do
  use Backlash.ConnCase

  alias Backlash.Repo
  alias Backlash.Setup
  alias Backlash.Project
  alias Backlash.Target

  test "GET /setups", %{conn: conn} do
    {:ok, target} = %Target{} |> Target.changeset(%{name: "niceproject"}) |> Repo.insert
    {:ok, stp} = target |> Ecto.build_assoc(:setups, %{name: "Noosfero-for-fedora25"}) |> Repo.insert
    conn = get conn, "/setups"
    assert html_response(conn, 200) =~ "Noosfero-for-fedora25"
  end

  test "GET /setups/new", %{conn: conn} do
    conn = get conn, "/setups/new"
    assert html_response(conn, 200)
  end

  test "GET /projects/1", %{conn: conn} do
    {:ok, target} = %Target{} |> Target.changeset(%{name: "niceproject"}) |> Repo.insert
    {:ok, setup} = target |> Ecto.build_assoc(:setups, %{name: "Noosfero-for-fedora25"}) |> Repo.insert
    conn = get conn, setup_path(conn, :show, setup.id)
    assert html_response(conn, 200) =~ "Noosfero-for-fedora25"
  end

  test "POST /setups with valid attrs", %{conn: conn} do
    setup_params = %{"name" => "Noosfero-for-fedora25"}
    l1 = length(Repo.all(Setup))
    post conn, setup_path(conn, :create, %{"setup" => setup_params})
    l2 = length(Repo.all(Setup))
    assert l1+1==l2
  end

  test "POST /setups with valid attrs and relationship", %{conn: conn} do
    {:ok, proj} = %Project{} |> Project.changeset(%{name: "Noosfero", description: "A nice community"}) |> Repo.insert
    setup_params = %{"name" => "Noosfero-for-fedora25"}
    l1 = length(Repo.all(Setup))
    proj = Repo.preload(proj, :setups)
    r1 = length(proj.setups)

    post conn, setup_path(conn, :create, %{"setup" => setup_params, "project_id" => proj.id})
    assert length(Repo.all(Setup))==l1+1
    proj = Project |> Repo.get(proj.id) |> Repo.preload(:setups)
    assert length(proj.setups)==r1+1
  end

  test "POST /setups with invalid attrs", %{conn: conn} do
    setup_params = %{"name" => "N"}
    l1 = length(Repo.all(Setup))
    post conn, setup_path(conn, :create, %{"setup" => setup_params})
    l2 = length(Repo.all(Setup))
    assert l1==(l2)
  end
end
