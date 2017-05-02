defmodule Customer.Web.Command.TechKeyword do
  use Customer.Command, model: Customer.Web.TechKeyword
  alias Customer.Web.TechKeyword
  alias Customer.Es

  def delete(tech_keyword) do
    Multi.new
    |> Multi.delete(:tech_keyword, tech_keyword)
    |> Multi.run(:delete_document, fn _ -> Es.Document.delete_document(tech_keyword) end)
  end

end