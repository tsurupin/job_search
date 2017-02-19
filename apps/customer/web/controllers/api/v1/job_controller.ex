defmodule Customer.Api.V1.JobController do
  use Customer.Web, :controller

  alias Customer.Job
  alias Customer.Repo
  alias Customer.Es

  def index(conn, params, _current_user, _claims) do
    search_params = search_params(params)
    option_params = option_params(params)

    jobs =
       Job.es_search(search_params, option_params)
       |> Es.Paginator.paginate(%{query: search_params, options: option_params})
    IO.inspect jobs
    render(conn, "index.json", %{jobs: jobs})
  end

  def show(conn, %{"id" => id}, _current_user, _claims) do
    case Repo.get(Job, id) do
      {:ok, job} -> render(conn, "show.json", %{job: job})
      {:error, error} -> render(conn, "show.json", %{error: error})
    end
  end

  defp search_params(params) do
    new_params = %{}
    if params["job-title"], do: new_params = Map.put_new(new_params, :job_title, params["job-title"])
    if params["area"], do: new_params = Map.put_new(new_params, :area, params["area"])
    if params["techs"], do: new_params = Map.put_new(new_params, :techs, String.split(params["techs"], ","))
    if params["detail"], do: new_params = Map.put_new(new_params, :detail, params["detail"])
    new_params
  end

  defp option_params(params) do
     new_params = %{page: params["page"] || 1, sort: params["sort"]}
     Map.put_new(new_params, :offset, params["offset"] || 0)
  end

end
