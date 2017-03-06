defmodule Customer.FavoriteJobs do
  use Customer.Web, :crud

  def all_by(user_id) do
    Repo.all(FavoriteJob.by_user_id(user_id))
  end

  def get(%{user_id: user_id, job_id: job_id} = params) do
    Repo.one(FavoriteJob.by_user_id_and_job_id(user_id, job_id))
  end

  def favorite(%{user_id: user_id, job_id: job_id} = params) do
    Repo.insert(FavoriteJob.build(params))
  end

  def update(%{job_id: job_id, user_id: user_id}, params) do
    if favorite_job = get_favorite_job(%{job_id: job_id, user_id: user_id}) do
      case Repo.update(FavoriteJob.update(favorite_job, params)) do
        {:ok, _} -> {:ok}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, "Not Found"}
    end
  end

  def unfavorite(%{job_id: job_id, user_id: user_id} = params) do
    if favorite_job = get_favorite_job(params) do
      case Repo.delete(favorite_job) do
        {:ok, _} -> {:ok}
        {:error, changeset} -> {:error, changeset}
      end
    else
      {:error, "Not Found"}
    end
  end

  defp get_favorite_job(%{job_id: job_id, user_id: user_id}) do
    Repo.get_by(FavoriteJob, job_id: job_id, user_id: user_id)
  end
end