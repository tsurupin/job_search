defmodule Customer.Web.Command.Authorization do
  use Customer.Command, model: Customer.Web.Authorization
  alias Customer.Web.Authorization

  def insert_by(multi, auth) do
    Multi.merge(multi, fn %{user: user} -> insert_by(Multi.new, user, auth) end)
  end

  def insert_by(multi, user, auth) do
    Multi.insert(multi, :authorization, Authorization.build_from_user_with_auth(user, auth))
  end

  def refresh_authorization(user, authorization) do
    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)

    Multi.new
    |> Multi.run(:guardian, fn _ -> refresh_guardian(jwt, full_claims) end)
    |> Multi.merge(fn %{guardian: guardian} ->
      Multi.update(Multi.new, :authorization, Authorization.update(authorization, guardian))
    end)
  end

  defp refresh_guardian(jwt, full_claims) do
    case Guardian.refresh!(jwt, full_claims) do
      {:ok, access_jwt, new_claims} -> {:ok, %{refresh_token: access_jwt, expired_at: new_claims["exp"] }}
      {error, reason} -> {:error, Atom.to_string(reason)}
    end
  end

end