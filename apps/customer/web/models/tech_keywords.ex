defmodule Customer.TechKeywords do
  use Customer.Web, :crud
  alias Customer.Es

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def delete(tech_keyword) do
    Multi.new
    |> Multi.delete(:tech_keyword, tech_keyword)
    |> Multi.run(:delete_document, fn _ -> Es.Document.delete_document(tech_keyword) end)
  end

  def pluck(query \\ __MODULE__, column) do
    TechKeyword.pluck(query, column)
    |> Repo.all
    |> Enum.map(&(&1[column]))
  end

end
