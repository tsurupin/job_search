defmodule Customer.Web.Command.AreaTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Area
  alias Customer.Web.Command

  describe "get_or_insert_by" do
    test "returns error if place is in unexpected format" do
      place = "test"
      multi =  Command.Area.get_or_insert_by(place)
      assert {:error, :area, "unexpected format", %{}} == Repo.transaction(multi)
    end

    test "returns error if place is not in USA" do
      place = "Sanfrancisco, CA"
      multi =  Command.Area.get_or_insert_by(place)
      assert {:error, :area, "not in USA", %{}} == Repo.transaction(multi)
    end

    test "returns error if place is not in existing states" do
       place = "Sanfrancisco, CA, USA"
       multi =  Command.Area.get_or_insert_by(place)
       assert {:error, :area, "state is not found", %{}} == Repo.transaction(multi)
    end

    test "returns area if area is not found" do
       state = insert(:state)
       area = insert(:area, state: state)

       place = "#{area.name}, #{state.abbreviation}, USA"
       multi = Command.Area.get_or_insert_by(place)
       assert {:ok, %{area: Repo.get(Area, area.id)}} == Repo.transaction(multi)

    end

    test "returns insert multi if area is not found" do
       state = insert(:state)
       area = insert(:area, state: state)
       place = "new_area, #{state.abbreviation}, USA"
       multi = Command.Area.get_or_insert_by(place)
       changeset = Area.build(%{name: "new_area", state_id: state.id})
       assert multi.operations == [{:area, {:changeset, %{changeset | action: :insert}, []}}]
    end

  end


end
