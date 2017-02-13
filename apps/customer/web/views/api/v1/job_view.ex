defmodule Customer.Api.V1.JobView do
  use Customer.Web, :view

  def render("index.json", %{jobs: jobs} = params) do
    params
  end

  def render("show.json", %{job: job} = params) do
    params
  end

  def render("show.json", %{error: error} = params) do
    params
  end
end
