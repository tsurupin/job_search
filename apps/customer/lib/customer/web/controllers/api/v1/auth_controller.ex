defmodule Customer.Web.Api.V1.AuthController do
  @moduledoc """
  Auth controller responsible for logout
  """
  use Customer.Web, :controller


  def delete(conn, _params, current_user, _claims) do
    if current_user do
      conn
      |> Guardian.revoke!
      send_resp(conn, 200, "")
    else
      conn
      |> send_resp(404, "")
    end
  end

end
