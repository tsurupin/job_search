defmodule Customer.Web.Query.FavoriteJob do
  use Customer.Query, model: Customer.Web.FavoriteJob
  alias Customer.Web.FavoriteJob

  def all_by(repo, %{user_id: user_id}) do
    repo.all(with_user_id_including_job(%{user_id: user_id}))
  end

  def with_user_and_job_id(repo, %{user_id: user_id, job_id: job_id} = params) do
    case repo.one(with_user_and_job_id(%{user_id: user_id, job_id: job_id})) do
      nil -> {:error, :not_found}
      favorite_job -> {:ok, favorite_job}
    end
  end

  def exists?(repo, params) do
    repo.one(count(params)) > 0
  end

  defp with_user_id_including_job(%{user_id: user_id} = params) when params == %{user_id: user_id} do
    from f in FavoriteJob,
    where: f.user_id == ^user_id,
    preload: [job: [:company, :job_title, :area]],
    order_by: [desc: f.interest]
  end

  defp with_user_and_job_id(%{user_id: user_id, job_id: job_id}) do
    from f in FavoriteJob,
    where: f.user_id == ^user_id and f.job_id == ^job_id
  end

  defp count(%{user_id: user_id, job_id: job_id} = params) do
    from f in with_user_and_job_id(params),
    select: count(f.id)
  end

end
