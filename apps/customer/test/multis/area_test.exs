defmodule Customer.Web.Multi.AreaTest do
  use Customer.Web.TestWithEcto, async: true

  alias Customer.Web.Multi

  describe "get_or_insert_by" do
    test "returns error if place is in unexpected format" do

    end
    test "returns error if place is not in USA" do
      place = "test"
      result = Multi.Area.get_or_insert_by(place)
      assert result == {:error, "unexpected_result"}
    end

    test "returns error if place is not in existing states" do
       place = "Sanfrancisco, CA"
       result = Multi.Area.get_or_insert_by(place)
       assert result == {:error, "not in USA"}
    end

    test "returns insert multi if area is not found" do
      place = "Sanfrancisco, CA, USA"
      result = Multi.Area.get_or_insert_by(place)
      assert result == {:error, "not in USA"}
    end

    test "returns area found" do
      state = insert(:state)
      area = insert(:area, state: state)
      place = "${area.name}, ${stae.abbereviation_name}, USA"
      multi = Multi.Area.get_or_insert_by(place)
      assert multi.name == [:area]

    end

  end


end
