defmodule Customer.Web.JobApplications do
  use Customer.Web, :crud

  def get_by(%{user_id: user_id, job_id: job_id, status: status} = params) do
    Repo.one(JobApplication.get_by(params))
  end

  def latest(%{user_id: user_id, job_id: job_id} = params) do
    Repo.one(JobApplication.latest(params))
  end
end