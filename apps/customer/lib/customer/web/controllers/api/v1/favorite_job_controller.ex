defmodule Customer.Web.Api.V1.FavoriteJobController do
  use Customer.Web, :controller
  alias Customer.Converter


  def index(conn, _params, current_user, _claims) do
    favorite_jobs = FavoriteJobs.all_by(%{user_id: current_user.id})
    render(conn, "index.json", %{favorite_jobs: favorite_jobs})
  end

  def show(conn, %{"id" => job_id}, current_user, _claims) do
    if favorite_job = FavoriteJobs.get_by(%{user_id: current_user.id, job_id: job_id}) do
      render(conn, "show.json", %{favorite_job_id: favorite_job.id})
    else
      render_with_404(conn, "Not Found")
    end
  end

  def create(conn, %{"id" => job_id}, current_user, _claims) do
    case FavoriteJobs.favorite(favorite_job_params(current_user.id, job_id)) do
      {:ok, _} -> send_resp(conn, 201, "")
      {:error, changeset} -> render_with_404(conn, Error.message(changeset))
    end

  end

  def update(conn, %{"id" => job_id} = params, current_user, _claims) do
    case FavoriteJobs.update(%{user_id: current_user.id, job_id: job_id}, Converter.convert_key_to_atom(Map.delete(params, "id"))) do
      {:ok, _} -> send_resp(conn, 200, "")
      {:error, changeset} -> render_with_404(conn, Error.message(changeset))
    end
  end

  def delete(conn, %{"id" => job_id}, current_user, _claims) do
    case FavoriteJobs.unfavorite(%{user_id: current_user.id, job_id: job_id}) do
      {:ok, _} -> send_resp(conn, 200, "")
      {:error, changeset} -> render_with_404(conn, Error.message(changeset))
    end
  end

  defp favorite_job_params(user_id, job_id) do
    %{
      user_id: user_id,
      job_id: job_id
     }
  end

  defp render_with_404(conn, error_message) do
    conn
    |> put_status(:not_found)
    |> render("error.json", %{error: error_message})
  end
end