defmodule Customer.Web.Command.CompanyTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Company
  alias Customer.Web.Command

  describe "get_or_insert_by" do
    test "returns company if company found" do
      company = insert(:company)
      multi = Command.Company.get_or_insert_by(%{name: company.name, url: company.url})
      assert {:ok, data } = Repo.transaction(multi)
      assert data.company == company
    end

    test "returns insert multi if company is not found" do
       params = %{name: "company", url: "url"}
       multi = Command.Company.get_or_insert_by(params)
       changeset = Company.build(params)
       assert multi.names == MapSet.new([:company])
       assert multi.operations == [{:company, {:changeset, %{changeset | action: :insert}, []}}]
    end

  end


end
