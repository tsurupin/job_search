defmodule Customer.Web.CompanyTest do
  use Customer.Web.TestWithEcto, async: true

  alias Customer.Web.Company

  @valid_attrs %{name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Company.changeset(%Company{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Company.changeset(%Company{}, @invalid_attrs)
    refute changeset.valid?
  end
end
