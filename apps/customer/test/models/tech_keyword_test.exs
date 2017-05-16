defmodule Customer.Web.TechKeywordTest do
  use Customer.Web.TestWithEcto, async: true

  alias Customer.Web.TechKeyword

  @valid_attrs %{name: "Docker", type: "infra"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TechKeyword.changeset(%TechKeyword{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TechKeyword.changeset(%TechKeyword{}, @invalid_attrs)
    refute changeset.valid?
  end


end
