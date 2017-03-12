defmodule Customer.Web.Api.V1.TechKeywordController do
  use Customer.Web, :controller

  def index(conn, %{"word" => word}, _current_user, _claims) do
    tech_keywords = Es.Suggester.completion(TechKeyword, word)
    render(conn, "index.json", %{tech_keywords: tech_keywords})
  end
end