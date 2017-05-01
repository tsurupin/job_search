defmodule Customer.Web.Query.JobApplication do
  use Customer.Query, model: Customer.Web.JobApplication
  alias Customer.Web.JobApplication

  def with_user_and_job_and_status(repo, %{user_id: user_id, job_id: job_id, status: status} = params) do
    repo.one(with_user_and_job_and_status(params))
  end

  def latest(repo, %{user_id: user_id, job_id: job_id} = params) do
    repo.one(latest(params))
  end

  defp with_user_and_job_and_status(%{user_id: user_id, job_id: job_id, status: status}) do
    from j in JobApplication,
    where: j.user_id == ^user_id and j.job_id == ^job_id and j.status == ^status
  end

  defp latest(%{user_id: user_id, job_id: job_id}) do
    from j in JobApplication,
    where: j.user_id == ^user_id and j.job_id == ^job_id,
    order_by: [desc: j.updated_at]
  end

end
