defmodule Customer.Services.JobSourceCreator do
  alias Customer.Repo
  alias Customer.{JobSource, JobSourceTechKeyword, TechKeyword, Company, Area, Company}

  @job_source_attributes [:company_id, :area_id, :title, :url, :job_title, :detail, :source]

  def perform(params) do
    Repo.transaction fn ->
      company = Company.find_or_create!(params.name, params.url)
      area = Area.find_from!(params.place)
      job_source =
        JobSource.find_or_initialize(params.url, params.job_title, params.source, area.id)
        |> JobSource.changeset(job_source_params(params, company, area))
        |> Repo.insert_or_update!

      upsert_job_source_tech_keywords!(params.keywords, job_source.id)
    end
  end

  defp job_source_params(params, company, area) do
    params
    |> Map.take(@job_source_attributes)
    |> Map.put_new(:company_id, company.id)
    |> Map.put_new(:area_id, area.id)
  end

  defp upsert_job_source_tech_keywords!(keyword_names, job_source_id) do
    tech_keywords = TechKeyword.by_names(keyword_names) |> Repo.all
    delete_job_source_tech_keywords_if_needed!(tech_keywords, job_source_id)
    Enum.each(tech_keywords, &(upsert_job_source_tech_keyword!(&1, job_source_id)))
  end

  defp upsert_job_source_tech_keyword!(keyword, job_source_id) do
    JobSourceTechKeyword.changeset(%JobSourceTechKeyword{}, %{tech_keyword_id: keyword.id, job_source_id: job_source_id})
    |> Repo.insert_or_update!
  end

  defp delete_job_source_tech_keywords_if_needed!(tech_keywords, job_source_id) do
    JobSourceTechKeyword.by_keyword_ids_and_source_id(tech_keyword_ids(tech_keywords), job_source_id)
    |> Repo.delete_all
  end

  defp tech_keyword_ids(keywords) do
    Enum.map(keywords, &(&1.id))
  end

end
