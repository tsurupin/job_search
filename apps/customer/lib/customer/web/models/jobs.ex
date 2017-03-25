defmodule Customer.Web.Jobs do
  use Customer.Web, :crud
  use Customer.Es

  def upsert(%JobSource{company_id: company_id, job_title: job_title, area_id: area_id} = job_source, job_title_id) do
    upsert(Multi.new, job_source, job_title_id)
  end

  def upsert(multi, %JobSource{company_id: company_id, job_title: job_title, area_id: area_id} = job_source, job_title_id) do
    job = Repo.get_by(Job, company_id: company_id, area_id: area_id, job_title_id: job_title_id)
    if job do
      Multi.update(multi, :job, Job.update(job, job_source))
    else
      Multi.insert(multi, :job, Job.build(%{company_id: company_id, area_id: area_id, job_title_id: job_title_id}, job_source))
    end
  end

  def delete(job) do
    Multi.new
    |> Multi.delete(:delete, job)
    |> Multi.run(:delete_document, fn _ -> Es.Document.delete_document(job) end)
  end

  def get_with_associations(id) do
    Job.get(id)
    |> first
    |> Repo.one
  end

  def by_company_id(company_id) do
    Job.by_company_id(company_id)
    |> Repo.all
  end



end
