defmodule Customer.Web.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth response on login
  """
  use Customer.Web, :controller
  plug Ueberauth

  alias Customer.Auth.Authorizer

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params, _current_user, _claims) do
    conn
    |> render("callback.json", %{error: "Failed to authenticate."})
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user, _claims) do

    case Authorizer.get_or_insert(auth, current_user) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :api)
        conn
        |> render("callback.html", token: jwt)
      {:error, reason} ->
        conn
        |> render("callback.html", error: reason)
    end
  end
end
