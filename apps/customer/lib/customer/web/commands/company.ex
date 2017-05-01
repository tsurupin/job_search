defmodule Customer.Web.Command.Company do
	use Customer.Command, model: Customer.Web.Company
	alias Customer.Web.Company
	alias Customer.Es


  def delete(company) do
     Multi.new
     |> Multi.delete(:delete, company)
     |> Multi.run(:delete_document, fn _ -> Es.Document.delete_document(company) end)
     |> Repo.transaction
   end

   def get_or_insert_by(%{name: name, url: url} = params), do: get_or_insert_by(Multi.new, params)

   def get_or_insert_by(multi, %{name: name, url: url} = params) do
     case Repo.get_by(Company, name: name) do
       nil -> Multi.insert(multi, :company, Company.build(params))
       company -> Multi.run(multi, :company, fn _ -> {:ok, company} end)
     end
   end

end
