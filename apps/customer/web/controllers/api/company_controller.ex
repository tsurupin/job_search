defmodule Customer.Api.CompanyController do
  use Customer.Web, :controller
  alias Customer.Conditions

  def index(conn, %{}) do
  end

  def index(conn, _) do
  end

  def show(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)
    render(conn, "show.json", company: company)
  end

end
