defmodule Customer.Web.Command.JobSource do
  use Customer.Command, model: Customer.Web.JobSource
  alias Customer.Web.JobSource

  def upsert(params), do: upsert(Multi.new, params)
  def upsert(multi, %{url: url, job_title: job_title, title: title, area_id: area_id, company_id: company_id, source: source, detail: detail} = params) do
    job_source = Repo.get_by(JobSource, url: url, job_title: job_title, source: source, area_id: area_id, company_id: company_id)
    if job_source do
      Multi.update(multi, :job_source, JobSource.update(job_source, %{title: title, detail: detail}))
    else
      Multi.insert(multi, :job_source, JobSource.build(params))
    end
  end

  def upsert(multi, %{url: url, job_title: job_title, title: title, area_id: area_id, company_id: company_id, source: source} = params) do
    upsert(multi, Enum.into(params, %{detail: nil}))
  end




end