defmodule Customer.Web.Api.V1.CompanyView do
  use Customer.Web, :view

  def index("index.json", %{companies: companies}) do

  end

  def show("show.json", %{company: company}) do
    %{

    }
  end
end
