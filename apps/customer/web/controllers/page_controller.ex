defmodule Customer.PageController do
  use Customer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
