defmodule Customer.Api.V1.JobView do
  use Customer.Web, :view

  def render("index.json", %{jobs: %{entries: jobs}} = params) do
    Enum.map(jobs, &(parse(&1)))
  end

  def render("show.json", %{job: job} = params) do
    params
  end

  def render("show.json", %{error: error} = params) do
    params
  end

  defp parse(job) do
    %{
        title: job.job_title,
        area_name: job.area_name,
        updated_time: job.updated_time,
        techs: job.techs,
        detail: job.detail
    }
  end
end
