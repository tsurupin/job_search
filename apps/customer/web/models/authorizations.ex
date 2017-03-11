defmodule Customer.Authorizations do
  use Customer.Web, :crud

  def current_auth(user_id) do
    Repo.one(Authorization.current_auth(user_id))
  end

  def get_user_by(authorization, current_user) do
    case Repo.one(Ecto.assoc(authorization, :user)) do
      nil -> {:error, :user_not_found}
      user ->
        if current_user && current_user.id != user.id do
          {:error, :user_does_not_match}
        else
          {:ok, user}
        end
    end
  end

  def create_by(user, auth) do
     Multi.new
     |> Multi.insert(:user, Authorization.build_with_auth(user, auth))
     |> Repo.transaction
  end

  def reset_authorization(authorization, user, auth) do
    Multi.new
    |> Multi.delete(:delete, authorization)
    |> Multi.merge(fn _ -> __MODULE__.create_by(user, auth) end)
    |> Repo.transaction
  end

end