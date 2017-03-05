defmodule Customer.Api.V1.JobController do
  use Customer.Web, :controller
  alias Customer.Ets

  def index(conn, params, _current_user, _claims) do
    search_params = search_params(params)
    option_params = option_params(params)

    jobs =
       Job.es_search(search_params, option_params)
       |> Es.Paginator.paginate(%{query: search_params, options: option_params})

    job_titles = fetch_from_ets("JobTitles", :names)
    areas = fetch_from_ets("Areas", :names)

    render(conn, "index.json", %{jobs: jobs, job_titles: job_titles, areas: areas})
  end

  def show(conn, %{"id" => id}, _current_user, _claims) do
    job = Jobs.get_with_associations(id)
    IO.inspect job
    if job do
      render(conn, "show.json", %{job: job})
    else
      conn
      |> put_status(:not_found)
      |> render("show.json", %{error: "Not Found"})
    end
  end

  defp search_params(params) do
    new_params = %{}
    if params["job-title"], do: new_params = Map.put_new(new_params, :job_title, params["job-title"])
    if params["area"], do: new_params = Map.put_new(new_params, :area, params["area"])
    if params["techs"], do: new_params = Map.put_new(new_params, :techs, params["techs"])
    if params["detail"], do: new_params = Map.put_new(new_params, :detail, params["detail"])
    new_params
  end

  defp option_params(params) do
     new_params = %{page: params["page"] || 1, sort: params["sort"]}
     Map.put_new(new_params, :offset, params["offset"] || 0)
  end

  defp fetch_from_ets(key, action) do
    case Ets.fetch(key) do
      {:ok, value} -> value
      {:error, _reason} ->
        upsert_ets(key, action)
        fetch_from_ets(key, action)
    end
  end

  defp upsert_ets(key, action) do
    value = apply(Module.concat(Customer, key), action, [])
    Ets.upsert(%{key: key, value: value})
  end


end
