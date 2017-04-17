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

  def get_or_create_by(place), do: get_or_create_by(Multi.new, place)


  def get_or_create_by(multi, place) do
    case area_name_and_state(place) do
      {:ok, area_name, state} ->
        params = %{name: area_name, state_id: state.id}
        case Repo.get_by(Area, params) do
          nil ->
            Multi.insert(multi, :area, Area.build(params))
          area -> Multi.run(multi, :area, fn _ -> {:ok, area} end)
        end
      {:error, reason} ->
        Multi.run(multi, :area, fn _ -> {:error, reason} end)
    end
  end

  defp trim(place) do
    place
    |> String.split(",")
    |> Enum.map(&(String.trim(&1)))
  end

  defp area_name_and_state(place) do
    case trim(place) do
      [_area_name, _state_abbreviation] -> {:error, "not in USA"}
      [area_name, state_abbreviation, _country] ->
        case Repo.get_by(State, %{abbreviation: state_abbreviation}) do
          nil -> {:error, "not state"}
          state -> {:ok, area_name, state}
        end
    end
  end




end
