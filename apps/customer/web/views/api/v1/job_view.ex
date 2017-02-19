defmodule Customer.Api.V1.JobView do
  use Customer.Web, :view

  def render("index.json", %{jobs: %{entries: jobs, has_next: has_next, next_page: next_page, page: page}} = params) do
    %{
       jobs: Enum.map(jobs, &(parse(&1))),
       hasNext: has_next,
       nextPage: next_page,
       page: page
    }
  end

  def render("show.json", %{job: job} = params) do
    params
  end

  def render("show.json", %{error: error} = params) do
    params
  end

  defp parse(job) do
    %{
        jobTitle: job.job_title,
        area: job.area,
        updatedAt: job.updated_at,
        techs: job.techs,
        detail: job.detail
    }
  end
end
