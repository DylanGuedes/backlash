defmodule Backlash.UserTest do
  use Backlash.ModelCase

  import Backlash.Factory

  alias Backlash.User
  alias Backlash.Repo

  test "changeset with valid attributes" do
    assert {:ok, _} = Repo.insert(User.changeset(%User{}, params_for(:user)))
  end

  test "raw pass must be cleaned" do
    user = insert(:user)
    us = Repo.get(User, user.id)
    assert us.password==nil
  end

end
