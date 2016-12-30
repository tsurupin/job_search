defmodule Customer.UserActivityTest do
  use Customer.ModelCase

  alias Customer.UserActivity

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserActivity.changeset(%UserActivity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserActivity.changeset(%UserActivity{}, @invalid_attrs)
    refute changeset.valid?
  end
end
