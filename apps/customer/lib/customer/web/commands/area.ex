defmodule Customer.Web.Command.Area do
	use Customer.Command, model: Customer.Web.Area
	alias Customer.Web.{State, Area}
	alias Customer.Web.Query
	alias Customer.Es

  def get_or_insert_by(place), do: get_or_insert_by(Multi.new, place)

  def get_or_insert_by(multi, place) do
    case area_name_and_state(place) do
      {:ok, area_name, state} ->
        params = %{name: area_name, state_id: state.id}
        case Repo.get_by(Area, params) do
          nil ->
            Multi.insert(multi, :area, Area.build(params))
          area ->
            Multi.run(multi, :area, fn _ -> {:ok, area} end)
        end
      {:error, reason} ->
        Multi.run(multi, :area, fn _ -> {:error, reason} end)
    end
  end

  defp area_name_and_state(place) do
    case trim(place) do
      [_area_name, _state_abbreviation] -> {:error, "not in USA"}
      [area_name, state_abbreviation, _country] ->
        case Repo.get_by(State, %{abbreviation: state_abbreviation}) do
          nil -> {:error, "state is not found"}
          state -> {:ok, area_name, state}
        end
      _ -> {:error, "unexpected format"}
    end
  end

	defp trim(place) do
	  place
		|> String.split(",")
		|> Enum.map(&(String.trim(&1)))
	end

end
