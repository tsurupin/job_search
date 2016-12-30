defmodule Customer.CompanyCacheTest do
  use Customer.ModelCase

  alias Customer.CompanyCache

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CompanyCache.changeset(%CompanyCache{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CompanyCache.changeset(%CompanyCache{}, @invalid_attrs)
    refute changeset.valid?
  end
end
