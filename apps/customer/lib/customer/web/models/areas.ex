defmodule Customer.Web.Areas do
  use Customer.Web, :crud
  alias Customer.Es

  def names do
    Area.names |> Repo.all
  end

  def delete(area) do
    Multi.new
    |> Multi.delete(:delete, area)
    |> Multi.run(:delete_document, fn _ -> Es.Document.delete_document(area) end)
  end

  def get_by!(place) do
    [area_name, state_abbreviation, _country] = area_and_state(place)
    state = Repo.get_by!(State, %{abbreviation: state_abbreviation})
    Repo.get_by!(Area, %{state_id: state.id, name: area_name})
  end

  defp area_and_state(place) do
    place
    |> String.split(",")
    |> Enum.map(&(String.trim(&1)))
  end


end
