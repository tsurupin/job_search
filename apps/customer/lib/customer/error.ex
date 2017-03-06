defprotocol Customer.Error do
  @fallback_to_any ""
  def message(data)
end

defimpl Customer.Error, for: Ecto.Changeset do
  def message(changeset) do
    Enum.map(changeset.errors, &(build_error_message(&1)))
    |> Enum.join(", ")
  end

  defp build_error_message(params) do
    IO.inspect params
    {key, {message, _}} = params
    "#{Atom.to_string(key)}: #{message}"
  end
end

defimpl Customer.Error, for: Any do
  def message(_), do: ""
end
