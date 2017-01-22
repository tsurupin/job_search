defmodule Customer.Api.SessionController do
  use Customer.Web, :controller
  alias Customer.UserFromAuth
  alias Customer.User

  def delete(conn, params) do
    conn |> Guardian.Plug.sign_out(conn)
  end

end
