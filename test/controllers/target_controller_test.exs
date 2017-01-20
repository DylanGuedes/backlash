defmodule Backlash.TargetControllerTest do
  use Backlash.ConnCase

  alias Backlash.Repo
  alias Backlash.Target

  import Backlash.Factory

  test "GET /targets", %{conn: conn} do
    insert(:target)
    conn = get conn, "/targets"
    assert html_response(conn, 200) =~ "Fedora25"
  end

  test "GET /targets/new", %{conn: conn} do
    conn = get conn, "/targets/new"
    assert html_response(conn, 200)
  end

  test "GET /targets/1", %{conn: conn} do
    target = insert(:target)
    conn = get conn, target_path(conn, :show, target.id)
    assert html_response(conn, 200) =~ "Fedora25"
  end

  test "POST /targets with valid attrs", %{conn: conn} do
    target_params = params_for(:target)
    l1 = length(Repo.all(Target))
    post conn, target_path(conn, :create, %{"target" => target_params})
    l2 = length(Repo.all(Target))
    assert l1+1==l2
  end

  test "POST /projects with invalid attrs", %{conn: conn} do
    target_params = %{"name" => "N"}
    l1 = length(Repo.all(Target))
    post conn, target_path(conn, :create, %{"target" => target_params})
    l2 = length(Repo.all(Target))
    assert l1==l2
  end
end
