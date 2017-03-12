defmodule Customer.Web.Api.V1.TechKeywordView do
  use Customer.Web, :view

  def render("index.json", %{tech_keywords: tech_keywords}) do
    tech_keywords
  end

 end
