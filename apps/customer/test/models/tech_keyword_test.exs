defmodule Customer.TechKeywordTest do
  use Customer.TestWithEcto, async: true

  alias Customer.TechKeyword

  @valid_attrs %{name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TechKeyword.changeset(%TechKeyword{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TechKeyword.changeset(%TechKeyword{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "delete! with valid record" do
  end

  test "delete! with invalid record" do
  end

  test "by_names with empty names" do
  end

  test "by_names with invalid names" do

  end

  test "by_names with valid names" do
  end

  test "es_reindex" do
  end

  test "es_create_index" do
  end

  test "es_search without word" do
  end

  test "es_search with word" do

  end
end
