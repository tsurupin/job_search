defmodule Customer.Web.Command.JobTechKeyword do
  use Customer.Command, model: Customer.Web.JobTechKeyword
  alias Customer.Web.JobTechKeyword
  alias Customer.Web.Query


  def bulk_delete_and_upsert(tech_keyword_ids, job_id) do
    bulk_delete_if_needed(tech_keyword_ids, job_id)
    |> bulk_upsert(tech_keyword_ids, job_id)
  end

  defp bulk_delete_if_needed(tech_keyword_ids, job_id) do
    job_tech_keywords = Query.JobTechKeyword.by_job_id_except_tech_keyword_ids(job_id, tech_keyword_ids)
    Multi.new
    |> Multi.delete_all(:job_tech_keyword, job_tech_keywords)
  end

  def bulk_upsert(multi, [], job_id), do: multi

  def bulk_upsert(multi, [current_id| remainings], job_id) do
    upsert(current_id, job_id, multi)
    |> bulk_upsert(remainings, job_id)
  end

  defp upsert(tech_keyword_id, job_id, nil) do
    upsert(tech_keyword_id, job_id, Multi.new)
  end

  defp upsert(tech_keyword_id, job_id, multi) do
    job_tech_keyword = Repo.get_by(JobTechKeyword, tech_keyword_id: tech_keyword_id, job_id: job_id)
    params = %{tech_keyword_id: tech_keyword_id, job_id: job_id}
    # NOTE: Thie method may be used for bulk upsert, so uuid is used as name

    if job_tech_keyword do
      Multi.update(multi, Ecto.UUID.generate, JobTechKeyword.update(job_tech_keyword, params))
    else
      Multi.insert(multi, Ecto.UUID.generate, JobTechKeyword.build(params))
    end
  end



end