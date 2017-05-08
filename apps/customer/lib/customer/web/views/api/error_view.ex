defmodule Customer.Web.Api.ErrorView do
  use Customer.Web, :view

  def render("unauthorized.json",  _assigns) do
     %{errorMessage: "Not Authorized"}
  end

  def render("not_found.json",  _assigns) do
    %{errorMessage: "Not Found"}
  end

  def render("unprocessable_entity.json", %{error_message: error_message} = param) do
    %{errorMessage: error_message}
  end

end
