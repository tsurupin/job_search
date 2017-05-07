defmodule Customer.Web.Query.AreaTest do
  use Customer.Web.TestWithEcto, async: true

  alias Customer.Web.Query

  test "names" do
    state = insert(:state)
    area1 = insert(:area, state: state, name: "San Francisco")
    area2 = insert(:area, state: state, name: "Seattle")
    assert Query.Area.names(Repo) == [area1.name, area2.name]
  end

end
