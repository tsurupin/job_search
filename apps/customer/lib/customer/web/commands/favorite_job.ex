defmodule Customer.Web.Command.FavoriteJob do
	use Customer.Command, model: Customer.Web.FavoriteJob
	alias Customer.Web.FavoriteJob
	alias Customer.Web.Query
	alias Customer.Web.Command
	alias Customer.Es

  def favorite(%{user_id: user_id, job_id: job_id} = params) do
    if job_application = Query.JobApplication.latest(Repo, params) do
      params = Map.put_new(params, :status, job_application.status)
    end
    Multi.insert(Multi.new, :favorite_job, FavoriteJob.build(params))
  end

  def unfavorite(%{job_id: job_id, user_id: user_id} = params) do
    case Query.FavoriteJob.get_by_user_and_job_id(Repo, params) do
      {:ok, favorite_job} -> {:ok, Multi.delete(Multi.new, :favorite_job, favorite_job)}
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  @job_application_attributes [:status, :comment]
  @favorite_job_attributes [:interest, :remarks, :status]

  def update_by(%{job_id: job_id, user_id: user_id} = required_params, params) do
    case Query.FavoriteJob.get_by_user_and_job_id(Repo, required_params) do
      {:error, :not_found} -> {:error, :not_found}
      {:ok, favorite_job} ->
        Multi.new
         |> update_by(favorite_job, Map.take(params, @favorite_job_attributes))
         |> Command.JobApplication.update_by(Map.take(params, @job_application_attributes), Map.take(favorite_job, ~w(user_id job_id status)a))
    end
  end

  defp update_by(multi, favorite_job, params) when params == %{}, do: multi
  defp update_by(multi, favorite_job, params) do
    Multi.update(multi, :favorite_job, FavoriteJob.update(favorite_job, params))
  end

end
