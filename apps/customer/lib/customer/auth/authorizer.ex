defmodule Customer.Auth.Authorizer do
  @moduledoc """
  Retrieve the user information from a auth request
  """
  alias Customer.Repo
  alias Customer.Web.{User, Authorization}
  alias Customer.Web.Query
  alias Customer.Web.Command
  alias Ueberauth.Auth
  alias Ecto.Multi

  def get_or_insert(auth, current_user \\ nil) do

    case validate_auth(auth) do
      {:error, :not_found} -> register_user_from_auth(current_user, auth)
      authorization ->
        if Authorization.expired?(authorization) do
          replace_authorization(authorization, auth, current_user || authorization.user)
        else
          Query.Authorization.user_by(authorization, current_user || authorization.user)
        end
    end
  end


  defp register_user_from_auth(current_user, auth) do
    multi  =
      Multi.new
      |> get_or_insert_user(current_user, auth)
      |> Command.Authorization.insert_by(auth)

    case Repo.transaction(multi)  do
      {:ok, data} -> {:ok, data.user}
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_or_insert_user(multi, current_user, auth) when is_nil(current_user) do
    Command.User.get_or_insert_by(multi, auth)
  end
  defp get_or_insert_user(multi, current_user, _auth) do
    Multi.run(multi, :user, fn _ -> {:ok, current_user} end)
  end

  defp replace_authorization(authorization, auth, current_user) do
    case Query.Authorization.user_by(authorization, current_user) do
      {:error, reason} -> {:error, reason}
      {:ok, user} ->
        case Command.Authorization.refresh_authorization(user, authorization) |> Repo.transaction do
          {:ok, _authorization} -> {:ok, user}
          _ -> {:error, "Failed to replace authorization"}
        end
    end
  end

  defp validate_auth(%{provider: provider, uid: auth_uid} = auth) when provider in [:google] do
    case Query.Authorization.get_by_uid_and_provider(%{uid: auth_uid, provider: to_string(provider)}) do
      nil -> {:error, :not_found}
      authorization -> authorization
    end
  end

end
