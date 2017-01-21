defmodule Customer.Auth.Plug.LoginRequried do
  import Plug.Conn
  alias Customer.User

  def init(opts), do: opts

  def call(conn, opts) do
    if user = current_user(conn, opts) do
      assign(conn, :current_user, user)
    else
      redirect(conn, opts)
    end
  end

  defp current_user(conn, _opts) do
    case GuardianPlug.current_resource(conn) do
      user -> user
      _ -> false
    end
  end

  defp default_path(conn) do
    Customer.Router.Helpers.admin_auth_path(conn,:signin)
  end

  defp redirect(conn, []), do: redirect(conn, to: default_path(conn))
  defp redirect(conn, nil), do: redirect(conn, to: default_path(conn))

  defp redirect(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> halt
  end
end
