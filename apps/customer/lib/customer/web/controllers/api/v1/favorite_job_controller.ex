defmodule Customer.Web.Api.V1.FavoriteJobController do
  use Customer.Web, :controller
  alias Customer.Converter
  action_fallback Customer.Web.Api.FallbackController

  def index(conn, _params, current_user, _claims) do
    favorite_jobs = FavoriteJobs.all_by(%{user_id: current_user.id})
    IO.inspect favorite_jobs
    render(conn, "index.json", %{favorite_jobs: favorite_jobs})
  end

  def show(conn, %{"id" => job_id}, current_user, _claims) do
    with {:ok, favorite_job} <- FavoriteJobs.get_by(%{user_id: current_user.id, job_id: job_id}) do
      render(conn, "show.json", %{favorite_job_id: favorite_job.id})
    end
  end

  def create(conn, %{"id" => job_id}, current_user, _claims) do
    with {:ok, _} <- FavoriteJobs.favorite(favorite_job_params(current_user.id, job_id)) do
      send_resp(conn, 201, "")
    end
  end

  def update(conn, %{"id" => job_id} = params, current_user, _claims) do
    IO.puts "---------------------"
    IO.inspect params

    with {:ok, _ } <- FavoriteJobs.update(%{user_id: current_user.id, job_id: job_id}, Converter.convert_key_to_atom(Map.delete(params, "id"))) do
      send_resp(conn, 200, "")
    end
  end

  def delete(conn, %{"id" => job_id}, current_user, _claims) do
    with {:ok, _} <- FavoriteJobs.unfavorite(%{user_id: current_user.id, job_id: job_id}) do
      send_resp(conn, 200, "")
    end
  end

  defp favorite_job_params(user_id, job_id) do
    %{
      user_id: user_id,
      job_id: job_id
     }
  end

end