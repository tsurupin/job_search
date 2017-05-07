defmodule Customer.Web.Command.JobApplication do
  use Customer.Command, model: Customer.Web.JobApplication
  alias Customer.Web.JobApplication
  alias Customer.Web.Query
  alias Customer.Repo
  alias Ecto.Multi

  def update_by(multi, %{comment: comment} = job_application_params, required_params) when job_application_params == %{comment: comment} do
    if job_application = Query.JobApplication.get_by_user_and_job_and_status(Repo, required_params) do
      Multi.update(multi, :job_application, JobApplication.update(job_application, job_application_params))
    else
      Multi.run(multi, :job_application, fn _ -> {:error, :not_found} end)
    end
  end

  def update_by(multi, job_application_params, required_params) do
    params = Enum.into(Map.take(required_params, [:user_id, :job_id]), job_application_params)
    insert_or_update_by(multi, params)
  end

  defp insert_or_update_by(multi, %{user_id: user_id, job_id: job_id} = params)  do
    case Query.JobApplication.latest(Repo, %{user_id: user_id, job_id: job_id}) do
      nil -> Multi.insert(multi, :job_application, JobApplication.build(params))
      job_application -> Multi.update(multi, :job_application, JobApplication.update(job_application, params))
    end
  end

end
