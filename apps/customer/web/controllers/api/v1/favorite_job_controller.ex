defmodule Customer.Api.V1.FavoriteJobController do
  use Customer.Web, :controller

   plug Guardian.Plug.EnsureAuthenticated

  def index(conn, params, current_user, _claimers) do

  end

  def create(con, params, current_user, _claimers) do

  end

  def update(conn, params, current_user, _claimers) do

  end

  def delete(con, params, current_user, _claims) do

  end
end
