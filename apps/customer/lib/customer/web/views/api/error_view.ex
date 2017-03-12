defmodule Customer.Web.Api.ErrorView do
  use Customer.Web, :view

  def render("unauthorized.json",  _assigns) do
     %{errorMessage: "Not Authorized"}
  end

  def render("not_found.json",  _assigns) do
     %{errorMessage: "Not Found"}
  end

  def render("unprocessable_entity.json", %{errorMessage: errorMessage} = param) do
    %{errorMessage: errorMessage}
  end

end
