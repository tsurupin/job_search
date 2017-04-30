defmodule Customer.Web.Command.Authorization do
  use Customer.Command, model: Customer.Web.Authorization
  alias Customer.Web.Authorization

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