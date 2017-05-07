defmodule Scraper.Site.Helper.AttributeBuilder do
  defmodule AttributeSource do
    defstruct [:index, :text, :label]
  end

  def perform(text, attribute_list) do
    attribute_sources = build_attribute_sources(text, attribute_list)
    build_attributes(attribute_sources, text)
  end

  defp build_attribute_sources(detail, attribute_sources \\ [], attribute_list)

  defp build_attribute_sources(_, attribute_sources, []) do
    Enum.filter(attribute_sources, fn(source) -> source != nil end)
  end

  defp build_attribute_sources(detail, attribute_sources, [attribute_label | tail]) do
     case build_attribute_source(detail, attribute_label) do
       nil ->  build_attribute_sources(detail, attribute_sources, tail)
       attribute_source -> build_attribute_sources(detail, attribute_sources ++ [attribute_source], tail)
     end
  end

  defp build_attribute_source(text, attribute_label) do
    case Regex.run(~r/.*(#{attribute_label})/i, text, return: :index) do
      [_, {index, _}] when is_integer(index)  ->
        text = Regex.run(~r/(#{attribute_label})/i, text) |> Enum.at(0)
        %AttributeSource{index: index, text: text, label: attribute_label}
      _ -> nil
    end
  end

  defp build_attributes(attributes, detail) do
    if Enum.any?(attributes) do
      build(detail, sorted_attributes(attributes))
    else
      build(detail, [])
    end
  end

  defp sorted_attributes(attributes) do
     Enum.sort(attributes, &(&1.index > &2.index))
  end

  defp build(text, indice, attributes \\ %{})

  defp build("", [], attributes), do: attributes

  defp build(text, [], attributes) do
    Map.put_new(attributes, "description", trim(text))
  end

  defp build(text, [attribute | tail], attributes) do
    [remaining_text, current_text] = Regex.split(~r{#{attribute.text}}, text)
    attributes = Map.put_new(attributes, attribute.label, trim(current_text))
    build(remaining_text, tail, attributes)
  end

  defp trim(text) do
    text
    |> String.replace(~r/^:*/, "")
    |> String.replace(~r/^[\r\n]*/, "", global: true)
    |> String.replace(~r/[\r\n]*$/, "", global: true)
  end
end
