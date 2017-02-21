defmodule Customer.Services.JobSourceCreator do
  alias Customer.Repo
  alias Customer.{JobTitle, JobTitleAlias, JobSource, JobSourceTechKeyword, TechKeyword, JobTechKeyword, Company, Area, Job, Company}
  @job_source_attributes [:company_id, :area_id, :title, :url, :job_title, :detail, :source]

  def perform(params) do
    Repo.transaction fn ->
      company = Company.find_or_create_by!(params.name, params.url)
      area = Area.find_by!(params.place)

      job_source = upsert_job_source!(params, company.id, area.id)
      bulk_upsert_job_source_tech_keywords!(params.keywords, job_source.id)
      job_title_id = get_or_create_job_title!(job_source.job_title)

      upsert_job!(job_source, job_title_id)
      |> bulk_upsert_job_tech_keywords_if_needed!
    end
  end

  defp upsert_job_source!(params, company_id, area_id) do
    JobSource.find_or_initialize_by(params.url, params.job_title, params.source, area_id)
    |> JobSource.changeset(job_source_attributes(params, company_id, area_id))
    |> Repo.insert_or_update!
  end

  defp get_or_create_job_title!(job_title) do
    case JobTitleAlias.get_or_find_approximate_job_title(job_title) do
      {:ok, job_title_id} -> job_title_id
      {:error, _} ->
         job_title = create_job_title_and_alias!(job_title)
         job_title.id
    end
  end

  defp create_job_title_and_alias!(name) do
    job_title =
      JobTitle.changeset(%JobTitle{}, %{name: name})
      |> Repo.insert!
    JobTitleAlias.changeset(%JobTitleAlias{}, %{name: name, job_title_id: job_title.id})
    |> Repo.insert!
    job_title
  end

  defp upsert_job!(%JobSource{company_id: company_id, job_title: job_title, area_id: area_id} = job_source, job_title_id) do
    job = Job.find_or_initialize_by(company_id, area_id, job_title_id)
    Job.changeset(job, update_attributes(job, job_source))
    |> Repo.insert_or_update!
  end

  defp bulk_upsert_job_source_tech_keywords!(keyword_names, _job_source_id) when is_nil(keyword_names), do: nil
  defp bulk_upsert_job_source_tech_keywords!(keyword_names, job_source_id) do
    TechKeyword.by_names(keyword_names)
    |> TechKeyword.pluck(:id)
    |> JobSourceTechKeyword.bulk_upsert!(job_source_id)
  end

  defp bulk_upsert_job_tech_keywords_if_needed!(%Job{detail: detail}) when is_nil(detail), do: nil
  defp bulk_upsert_job_tech_keywords_if_needed!(%Job{id: id, detail: detail}) do
    JobSourceTechKeyword.tech_keyword_ids_by(detail["job_source_id"])
    |> JobTechKeyword.bulk_upsert!(id)
  end

  defp update_attributes(%Job{url: url, title: title, detail: detail}, job_source) do
    %{}
    |> update_map_attribute(url, :url, job_source)
    |> update_map_attribute(title, :title, job_source)
    |> update_map_attribute(detail, :detail, job_source)
  end

  defp update_map_attribute(attributes, attribute, column_name, job_source) do
    if attribute == nil || Map.get(attribute, "priority") <= job_source.priority do
      Map.put_new(
        attributes,
        column_name,
        %{
          "value" => Map.get(job_source, column_name),
          "priority" => job_source.priority,
          "job_source_id" => job_source.id
        }
      )
    else
      attributes
    end
  end

  defp job_source_attributes(params, company_id, area_id) do
    params
    |> Map.take(@job_source_attributes)
    |> Map.put_new(:company_id, company_id)
    |> Map.put_new(:area_id, area_id)
  end

end
