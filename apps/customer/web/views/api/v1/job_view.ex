defmodule Customer.Api.V1.JobView do
  use Customer.Web, :view

  def render("index.json", %{jobs: %{entries: jobs, has_next: has_next, next_page: next_page, page: page}, job_titles: job_titles, areas: areas} = params) do
   %{
       jobs: Enum.map(jobs, &(parse(&1))),
       hasNext: has_next,
       nextPage: next_page,
       page: page,
       jobTitles: job_titles,
       areas: areas
    }
  end

  def render("show.json", %{job: job} = params) do
    parse(job)
  end

  def render("show.json", %{error: error} = params) do
    params
  end

  defp parse(%{job_id: id, job_title: job_title, area: area, updated_at: updated_at,techs: techs, detail: detail}) do
    %{
        id: id,
        jobTitle: job_title,
        area: area,
        updatedAt: updated_at,
        techs: techs,
        detail: detail
    }
  end

  defp parse(%{id: id, job_title: job_title, area: area, updated_at: updated_at, detail: detail}) do
      %{
          id: id,
          jobTitle: job_title,
          area: area.name,
          updatedAt: updated_at,
          detail: detail["value"]
      }
    end

end
