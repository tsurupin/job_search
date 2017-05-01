defmodule Customer.Web.UserTest do
  use Customer.Web.TestWithEcto, async: true

  alias Customer.Web.User

  @valid_attrs %{email: "test@sample.com", name: "name"}
  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end


  @invalid_attrs %{email: "test", name: "name"}
  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end


end
