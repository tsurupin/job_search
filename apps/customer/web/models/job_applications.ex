defmodule Customer.JobApplications do
  use Customer.Web, :crud

  def get_by(%{user_id: user_id, job_id: job_id, status: status} = params) do
    Repo.one(JobApplication.get_by(params))
  end

#  def record(%{user_id: user_id, job_id: job_id, status: status} = required_params, comment \\ nil) do
#    if job_application = Repo.one(JobApplication.get(required_params)) do
#      Repo.update(JobApplication.update(job_application, %{comment: comment}))
#    else
#      Repo.insert(JobApplication.build(Enum.into(required_params, %{comment: comment})))
#    end
#  end

  def latest(%{user_id: user_id, job_id: job_id} = params) do
    Repo.one(JobApplication.latest(params))
  end
end