defmodule Customer.Companies do
  use Customer.Web, :crud
  alias Customer.Es

  def delete(company) do
    Multi.new
    |> Multi.delete(:delete, company)
    |> Multi.run(:delete_document, fn _ -> Es.Document.delete_document(company) end)
    |> Repo.transaction
  end

  def delete!(model) do
    Repo.transaction(fn ->
      Repo.delete! model
      Es.Document.delete_document model
    end)
  end

  def find_or_create_by!(name, url) do
    case Repo.get_by(Company, name: name) do
      nil -> Repo.insert!(Company.build(%{name: name, url: url}))
      company -> company
    end
  end

end
