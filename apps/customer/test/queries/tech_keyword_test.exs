defmodule Customer.Web.Query.TechKeywordTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Query
  alias Customer.Repo

  describe "pluck_with_names" do
    test "return ids" do
      tech_keyword1 = insert(:tech_keyword, name: "test1")
      tech_keyword2 = insert(:tech_keyword, name: "sample")
      tech_keyword3 = insert(:tech_keyword, name: "test2")
      assert Query.TechKeyword.pluck_with_names(Repo, ["test1", "test2"], :id) == [tech_keyword1.id, tech_keyword3.id]
    end

  end

end
