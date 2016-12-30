defmodule Customer.CompanySourceTest do
  use Customer.ModelCase

  alias Customer.CompanySource

  @valid_attrs %{name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CompanySource.changeset(%CompanySource{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CompanySource.changeset(%CompanySource{}, @invalid_attrs)
    refute changeset.valid?
  end
end
