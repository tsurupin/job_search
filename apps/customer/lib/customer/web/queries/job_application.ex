defmodule Customer.Web.Query.JobApplication do
  use Customer.Query, model: Customer.Web.JobApplication
  alias Customer.Web.JobApplication

  def get_by_user_and_job_and_status(repo, %{user_id: user_id, job_id: job_id, status: status} = params) do
    repo.one(by_user_and_job_and_status(params))
  end

  def latest(repo, %{user_id: user_id, job_id: job_id} = params) do
    by_user_id_and_job_id(params)
    |> recent
    |> first
    |> repo.one
  end

  defp recent(query \\ JobApplication) do
    from j in query,
    order_by: [desc: j.updated_at]
  end

  defp by_user_and_job_and_status(query \\ JobApplication, %{user_id: user_id, job_id: job_id, status: status}) do
    from j in query,
    where: j.user_id == ^user_id and j.job_id == ^job_id and j.status == ^status
  end

  defp by_user_id_and_job_id(%{user_id: user_id, job_id: job_id}, query \\ JobApplication) do
    from j in query,
    where: j.user_id == ^user_id and j.job_id == ^job_id
  end

end
