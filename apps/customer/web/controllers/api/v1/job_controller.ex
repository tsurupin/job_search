defmodule Customer.Api.V1.JobController do
  use Customer.Web, :controller

  alias Customer.Job
  alias Customer.Repo

  def index(conn, %{"search" => search_params, "option" => option_params}, _current_user, _claims) do
    jobs = Job.es_search(search_params, option_params)
    render("index.json", %{jobs: jobs})
  end

  def show(conn, %{"id" => id}, _current_user, _claims) do
    case Repo.get(Job, id) do
      {:ok, job} -> render("show.json", %{job: job})
      {:error, error} -> render("show.json", %{error: error})
    end
  end

  # defp search_params(params) do
  #
  #   %{
  #     id: params.id,
  #     title: params.title,
  #     job_title: params.job_title,
  #     detail: params.detail,
  #     company_name: params.company_name,
  #     area_name: params.area_name,
  #     techs: params.techs,
  #     updated_time: params.updated_time
  #   }
  # end
  #
  # defp option_params(params) do
  #   %{
  #     offset: params.offset,
  #     per_page: params.per_page,
  #     sort: params.sort
  #   }
  # end

end
