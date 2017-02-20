defmodule Customer.API.V1.TechKeywordController do
  use Customer.Web, :controller

  alias Customer.Es
  alias Customer.TechKeyword

  def index(conn, %{"word" => word}, _current_user, _claims) do
    tech_keywords = Es.Suggester.completion(TechKeyword, word)
    render(conn, "index.json", %{tech_keywords: tech_keywords})
  end
end