defmodule Customer.Api.V1.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth response
  """
  use Customer.Web, :controller
  plug Guardian.Plug.EnsureAuthenticated

  def delete(conn, _params, current_user, _claims) do
    if current_user do
      conn
      |> Guardian.revoke!
      #|> Guardian.Plug.sign_out
      |> render("logout.json", %{message: "Signed out"})
    else
      conn
      |> render("logout.json", %{error: "Not logged in"})
    end
  end

end
