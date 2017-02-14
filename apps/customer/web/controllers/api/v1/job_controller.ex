defmodule Customer.Api.V1.JobController do
  use Customer.Web, :controller

  alias Customer.Job
  alias Customer.Repo

  def index(conn, params, _current_user, _claims) do
    jobs = Job.es_search(search_params(params), option_params(params))
    # TODO: fetching page & offset
    render("index.json", %{jobs: jobs})
  end

  def show(conn, %{"id" => id}, _current_user, _claims) do
    case Repo.get(Job, id) do
      {:ok, job} -> render("show.json", %{job: job})
      {:error, error} -> render("show.json", %{error: error})
    end
  end

  defp search_params(params) do
    new_params = %{}
    if params["job-title"] do
      new_params = Map.put_new(new_params, :job_title, params["job-title"])
    end

    if params["area"] do
      new_params = Map.put_new(new_params, :area, params["area"])
    end

    if params["techs"] do
      new_params = Map.put_new(new_params, :techs, String.split(params["techs"], ","))
    end

    if params["detail"] do
      new_params = Map.put_new(new_params, :detail, params["detail"])
    end
    new_params
  end

  defp option_params(params) do
     new_params = %{page: params["page"], sort: params["sort"]}
     Map.put_new(new_params, :offset, params["offset"] || 0)
  end

end
