defmodule UserFromAuth do
  @moduledoc """
  Retrieve the user information from a auth request
  """
  alias Customer.Repo
  alias Customer.{User, Authorization}
  alias Ueberauth.Auth

  def get_or_create(auth, current_user) do
    case validate_auth(auth) do
      {:error, :not_found} -> register_user_from_auth(current_user, auth)
      {:error, reason} -> {:error, reason}
      authorization ->
        if Authorization.expired?(authorization) do
          replace_authorization(authorization, auth, current_user)
        else
          Authorization.get_user_by(authorization, current_user)
        end
    end
  end

  defp register_user_from_auth(current_user, auth) do
    case Repo.transaction(fn ->
      user = current_user || User.get_or_create_by!(auth)
      Authorization.create_by!(user, auth)
      {:ok. user}
    end) do
      {:ok, user} -> {:ok. user}
      {:error, reason} -> {:error, reason}
    end
  end

  defp replace_authorization(authorization, auth, current_user) do
    case Authorization.get_user_by(authorization, current_user) do
      {:error, reason} -> {:error, reason}
      {:ok, user} ->
        case Authorization.reset_authorization(authorization, user, auth) do
          {:ok, _authorization} -> {:ok, user}
          {:error, reason} -> {:error, reason}
        end
    end
  end

  defp validate_auth(%{provider: provider, uid: auth_uid} = auth) when provider in [:google] do
    case Repo.get_by(Authorization, uid: auth_uid, provider: to_string(provider)) do
      {:ok, authorization} ->
        if authorization.uid == auth_uid do
          authorization
        else
          {:error, :uid_mismatch}
        end
      _ ->
        {:error, :not_found}
    end
  end

end
