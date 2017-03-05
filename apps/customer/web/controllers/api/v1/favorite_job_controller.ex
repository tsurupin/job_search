defmodule Customer.Api.V1.FavoriteJobController do
  use Customer.Web, :controller

  def index(conn, _params, current_user, _claims) do
    favorite_jobs = FavoriteJobs.all_by(current_user.id)
    render(conn, "index.json", %{favorite_jobs: favorite_jobs})
  end

  def show(conn, %{"id": job_id}, current_user, _claims) do
    if favorite_job = FavoriteJobs.get(%{user_id: current_user.id, job_id: job_id}) do
      render(conn, "show.json", %{favorite_job_id: favorite_job.id})
    else
      render(conn, "error.json", %{error: "not found"})
    end
  end

  def create(conn, %{"id": job_id}, current_user, _claims) do
    case FavoriteJobs.favorite(favorite_job_params(current_user.id, job_id)) do
      {:ok, _} -> render_resp(conn, 201, "")
      {:error, reason} -> render(conn, "error.json", %{error: reason})
    end
  end

  def update(conn, %{"id": id} = params, current_user, _claims) do
    case FavoriteJobs.update(id, params) do
      {:ok} -> render_resp(conn, 200, "")
      {:error, reason} -> render(conn, "error.json", reason)
    end
  end

  def delete(conn, %{"id": id}, current_user, _claims) do
    case FavoriteJobs.unfavorite(id) do
      {:ok} -> render_resp(conn, 200, "")
      {:error, reason} -> render(conn, "error.json", reason)
    end
  end

  defp favorite_job_params(user_id, job_id) do
    %{
      user_id: user_id,
      job_id: job_id
     }
  end
end