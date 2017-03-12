defmodule Customer.Web.PageController do
  use Customer.Web, :controller

  def index(conn, _params, _current_user, _claims) do
    render conn, "index.html"
  end
end
