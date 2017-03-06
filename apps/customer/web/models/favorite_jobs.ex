defmodule Customer.FavoriteJobs do
  use Customer.Web, :crud

  @job_application_attributes [:status, :comment]
  @favorite_job_attributes [:interest, :remarks, :status]

  def all_by(%{user_id: user_id}) do
    Repo.all(FavoriteJob.get_by(%{user_id: user_id}))
  end

  def get_by(%{user_id: user_id, job_id: job_id} = params) do
    Repo.one(FavoriteJob.get_by(%{user_id: user_id, job_id: job_id}))
  end

  def exists?(params) do
    Repo.one(FavoriteJob.count(params)) > 0
  end

  def favorite(%{user_id: user_id, job_id: job_id} = params) do
    if job_application = JobApplications.latest(params) do
      params = Map.put_new(params, :status, job_application.status)
    end
    Repo.insert(FavoriteJob.build(params))
  end

  def unfavorite(%{job_id: job_id, user_id: user_id} = params) do
    if favorite_job = get_favorite_job(params) do
      case Repo.delete(favorite_job) do
        {:ok, _} -> {:ok, nil}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, "Not Found"}
    end
  end

  def update(%FavoriteJob{} = favorite_job, params) do
      multi =
        Multi.new
        |> update_favorite_job(favorite_job, Map.take(params, @favorite_job_attributes))
        |> update_job_application(favorite_job, Map.take(params, @job_application_attributes))
      IO.inspect multi
      case Repo.transaction(multi) do
        {:ok, _} -> {:ok, nil}
        {:error, _, reason, _} -> {:error, reason}
      end
  end

  def update(%{job_id: job_id, user_id: user_id} = required_params, params) do
    if favorite_job = get_favorite_job(required_params) do
      update(favorite_job, params)
    else {:error, "Not Found"}
    end
  end

  defp update_favorite_job(multi, favorite_job, params) when params == %{}, do: multi
  defp update_favorite_job(multi, favorite_job, params) do
    Multi.update(multi, :favorite_job, FavoriteJob.update(favorite_job, params))
  end

  defp update_job_application(multi, favorite_job, %{comment: comment} = params) when params == %{comment: comment}   do
    if job_application = JobApplications.get_by(Map.take(favorite_job, [:user_id, :job_id, :status])) do
      Multi.update(multi, :job_application, JobApplication.update(job_application, %{comment: comment}))
    else

      Multi.run(multi, :job_application, fn _ -> {:error, "Not Found"} end)
    end
  end

  defp update_job_application(multi, favorite_job, params) do
    required_params = Map.take(favorite_job, [:user_id, :job_id])
    if job_application = JobApplications.latest(required_params) do
      Multi.update(multi, :job_application, JobApplication.update(job_application, params))
    else
      Multi.insert(multi, :job_application, JobApplication.build(Enum.into(params, required_params)))
    end
  end

  defp get_favorite_job(%{job_id: job_id, user_id: user_id}) do
    Repo.get_by(FavoriteJob, job_id: job_id, user_id: user_id)
  end

end