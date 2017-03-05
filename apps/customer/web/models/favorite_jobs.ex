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

  def update(id, params) do
    with {:ok, favorite_job} <- get_favorite_job(id),
         {:ok} <- Repo.update(FavoriteJob.update(favorite_job, params))
    do {:ok}
    else reason ->  {:error, reason}
    end
  end

  def unfavorite(id) do
    with {:ok, favorite_job} <- get_favorite_job(id),
         {:ok} <- Repo.delete(favorite_job)
    do {:ok}
    else reason ->  {:error, reason}
    end
  end

  defp get_favorite_job(id) do
    Repo.get(FavoriteJob, id)
  end
end