defmodule Customer.UserMemoTest do
  use Customer.ModelCase

  alias Customer.UserMemo

  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserMemo.changeset(%UserMemo{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserMemo.changeset(%UserMemo{}, @invalid_attrs)
    refute changeset.valid?
  end
end
