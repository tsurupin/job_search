defmodule Customer.Api.V1.TechKeywordView do
  use Customer.Web, :view

  def render("index.json", %{tech_keyword: tech_keywords}) do
    tech_keywords
  end

 end
