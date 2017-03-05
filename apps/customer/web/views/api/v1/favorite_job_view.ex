defmodule Customer.Api.V1.FavoriteJobView do
  use Customer.Web, :view

  def render("index.json", %{favorite_jobs: favorite_jobs}) do
    %{

    }

  end

  def render("create.json", %{favorite_job: favorite_job_id} = param) do
    param
  end

  def render("error.json", %{error: error} = param) do
    param
  end


end
