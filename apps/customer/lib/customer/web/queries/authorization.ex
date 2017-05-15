defmodule Customer.Web.Query.Authorization do
  use Customer.Query, model: Customer.Web.Authorization

  alias Customer.Web.Authorization

  def current_auth(user_id) do
    by_user_id(user_id, Authorization)
    |> last
    |> Repo.one
  end

  def get_by_uid_and_provider(%{uid: uid, provider: provider} = params) do
    by_uid_and_provider(uid, provider, Authorization)
    |> with_user
    |> Repo.one
  end

  def by_uid_and_provider(uid, provider, query) do
    from a in query,
    where: a.uid == ^uid and a.provider == ^provider
  end

  def by_user_id(user_id, query) do
    from a in query,
    where: a.user_id == ^user_id
  end

  def with_user(query) do
    from a in query, preload: [:user]
  end

  def user_by(authorization, current_user) when is_nil(current_user), do: {:error, :not_match}
  def user_by(authorization, current_user) do

    case Repo.one(Ecto.assoc(authorization, :user)) do
      nil -> {:error, :not_found}
      user ->
        if current_user.id != user.id do
          {:error, :not_match}
        else
          {:ok, user}
        end
    end
  end

end