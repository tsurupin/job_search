defmodule Customer.Api.V1.JobView do
  use Customer.Web, :view

  @default_attributes [:id, :name]

  def render("index.json", %{jobs: %{entries: jobs, has_next: has_next, next_page: next_page, page: page}, job_titles: job_title_names, areas: area_names} = params) do
   %{
       jobs: Enum.map(jobs, &(parse(&1))),
       hasNext: has_next,
       nextPage: next_page,
       page: page,
       jobTitles: job_title_names,
       areas: area_names
    }
  end

  def render("show.json", %{job: %Job{id: id, job_title: job_title, area: area, tech_keywords: tech_keywords, company: company, updated_at: updated_at, detail: detail} }) do
    %{
        id: id,
        jobTitle: job_title.name,
        area: area.name,
        techKeywords: fetch(tech_keywords),
        company: fetch(company),
        updatedAt: updated_at,
        detail: detail["value"]
    }
  end

  def render("show.json", %{error: error}) do
    %{
      error: error
    }
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

  defp fetch(records, columns \\ @default_attributes)

  defp fetch(records, columns) when is_list(records) do
    Enum.map(records, &(fetch(&1, columns)))
  end

  defp fetch(record, columns)  do
    Map.take(record, columns)
  end

end
