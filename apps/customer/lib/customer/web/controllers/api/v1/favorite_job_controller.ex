defmodule Customer.Web.Api.V1.FavoriteJobController do
  use Customer.Web, :controller
  alias Customer.Converter
  alias Customer.Web.Command
  alias Customer.Web.Query
  action_fallback Customer.Web.Api.FallbackController

  def index(conn, _params, current_user, _claims) do
    favorite_jobs = Query.FavoriteJob.all_by(Repo, %{user_id: current_user.id})
    render(conn, "index.json", %{favorite_jobs: favorite_jobs})
  end

  def show(conn, %{"id" => job_id}, current_user, _claims) do
    with {:ok, favorite_job} <- Query.FavoriteJob.get_by_user_and_job_id(Repo, %{user_id: current_user.id, job_id: job_id}) do
      render(conn, "show.json", %{favorite_job_id: favorite_job.id})
    end
  end

  def create(conn, %{"id" => job_id}, current_user, _claims) do
    multi = Command.FavoriteJob.favorite(favorite_job_params(current_user.id, job_id))
    case Repo.transaction(multi) do
      {:ok, _data} -> send_resp(conn, 201, "")
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  def update(conn, %{"id" => job_id} = params, current_user, _claims) do
    multi = Command.FavoriteJob.update_by(%{user_id: current_user.id, job_id: job_id}, Converter.convert_key_to_atom(Map.delete(params, "id")))
    case Repo.transaction(multi) do
      {:ok, _data} -> send_resp(conn, 200, "")
      {:error, _, changeset, _} -> {:error, changeset}
    end
  end

  def delete(conn, %{"id" => job_id}, current_user, _claims) do
    with {:ok, multi} <- Command.FavoriteJob.unfavorite(%{user_id: current_user.id, job_id: job_id}) do
      case Repo.transaction(multi) do
        {:ok, _data} -> send_resp(conn, 200, "")
      end
    else
      {:error, :not_found} -> {:error, :not_found}
    end

  end

  defp favorite_job_params(user_id, job_id) do
    %{
      user_id: user_id,
      job_id: job_id
     }
  end

end
