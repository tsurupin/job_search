defmodule Customer.Web.Authorizations do
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

  def get_by(%{uid: uid, provider: provider} = params) do
    Repo.one(Authorization.get_by(params))
  end

  def create_by(user, auth) do
     Multi.new
     |> Multi.insert(:user, Authorization.build_with_auth(user, auth))
  end

  def refresh_authorization(user, authorization) do
    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)

    Multi.new
    |> Multi.run(:guardian, fn _ ->
      case Guardian.refresh!(jwt, full_claims) do
        {:ok, access_jwt, new_claims} -> {:ok, %{refresh_token: access_jwt, expired_at: new_claims["exp"] }}
        {error, reason} -> {:error, Atom.to_string(reason)}
      end
    end)
    |> Multi.merge(fn %{guardian: guardian} ->
      Multi.update(Multi.new, :authorization, Authorization.update(authorization, guardian))
    end)

  end

end