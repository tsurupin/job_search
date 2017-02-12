defmodule Customer.Api.V1.CompanyController do
  use Customer.Web, :controller
  alias Customer.Conditions

  def index(conn, %{}) do
  end

  def index(conn, _) do
  end

  def show(conn, %{"id" => id}) do
    company = Repo.get!(__MODULE__, id)
    render(conn, "show.json", company: company)
  end

end
