defmodule Customer.Web.Api.V1.JobView do
  use Customer.Web, :view

  @default_attributes [:id, :name]

  def render("index.json", %{jobs: %{entries: jobs, has_next: has_next, next_page: next_page, page: page, total: total}, job_titles: job_title_names, areas: area_names} = params) do
   %{
       jobs: Enum.map(jobs, &(parse(&1))),
       hasNext: has_next,
       nextPage: next_page,
       page: page,
       total: total,
       jobTitles: capitalize(job_title_names),
       areas: area_names
    }
  end

  def render("show.json", %{job: %Job{id: id, job_title: job_title, title: title, area: area, tech_keywords: tech_keywords, company: company, detail: detail, favorited: favorited, url: url}, related_jobs: related_jobs }) do

    %{
        id: id,
        jobTitle: job_title.name,
        title: title["value"],
        area: area.name,
        techKeywords: fetch(tech_keywords),
        company: fetch(company),
        detail: detail["value"],
        url: url["value"],
        relatedJobs: parse_related_jobs(related_jobs)
    }
    |> add_favorite_if_existed(favorited)
  end

  def render("show.json", %{error: error}) do
    %{
      error: error
    }
  end

  defp parse(%{job_id: id, job_title: job_title, company_name: company_name, title: title, area: area, updated_at: updated_at, techs: techs, detail: detail, favorited: favorited} = params) when is_boolean(favorited) do
    %{
        id: id,
        jobTitle: job_title,
        title: title,
        companyName: company_name,
        area: String.capitalize(area),
        updatedAt: updated_at,
        techs: capitalize(techs),
        detail: detail,
        favorited: favorited
    }
  end

  defp parse(%{job_id: id, job_title: job_title, company_name: company_name, title: title, area: area, updated_at: updated_at,techs: techs, detail: detail} = params) do
    %{
        id: id,
        jobTitle: job_title,
        title: title,
        companyName: company_name,
        area: String.capitalize(area),
        updatedAt: updated_at,
        techs: capitalize(techs),
        detail: detail
    }
  end

  defp parse_related_jobs(related_jobs \\ [], job \\ [])
  defp parse_related_jobs([], jobs), do: jobs

  defp parse_related_jobs([current|remaining], jobs) do
    parse_related_jobs(remaining, jobs ++ [parse_related_job(current)])
  end

  defp parse_related_job(%Job{id: id, title: title, area: area} = job) do
    %{
      id: id,
      title: title["value"],
      area: area.name
    }
  end

  defp fetch(records, columns \\ @default_attributes)

  defp fetch(records, columns) when is_list(records) do
    Enum.map(records, &(fetch(&1, columns)))
  end

  defp fetch(record, columns)  do
    Map.take(record, columns)
  end

  defp add_favorite_if_existed(map, favorited) when is_nil(favorited), do: map
  defp add_favorite_if_existed(map, favorited) do
    Map.put_new(map, :favorited, favorited)
  end

  defp capitalize(words) when is_list(words) do
    words |> Enum.map(&(String.capitalize(&1)))
  end


end
