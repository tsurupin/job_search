defmodule Customer.Web.Api.V1.JobController do
  use Customer.Web, :controller
  alias Customer.Ets
  @search_candidates [["job-title", :job_title], ["areas", :areas], ["techs", :techs], ["detail", :detail]]

  def index(conn, params, current_user, _claims) do
    search_params = search_params(params)
    option_params = option_params(params)

    jobs =
       Job.es_search(search_params, option_params)
       |> Es.Paginator.paginate(%{query: search_params, options: option_params})
       |> add_favorite_if_needed(current_user)

    job_titles = fetch_from_ets("JobTitles", :names)
    areas = fetch_from_ets("Areas", :names)
    IO.inspect jobs

    render(conn, "index.json", %{jobs: jobs, job_titles: job_titles, areas: areas})
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    job = Jobs.get_with_associations(id)

    if job do
      job = add_favorite(job, current_user)
      render(conn, "show.json", %{job: job})
    else
      conn
      |> put_status(:not_found)
      |> render("show.json", %{error: "Not Found"})
    end
  end


  defp search_params(params, candidates \\ @search_candidates, new_params \\ %{})
  defp search_params(_, [], new_params), do: new_params

  defp search_params(params, [[str, atom_str] | remainings], new_params) do
    if params[str] do
      search_params(params, remainings, Map.put_new(new_params, atom_str, params[str]))
    else
      search_params(params, remainings, new_params)
    end
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
    value = apply(Module.concat(Customer.Web, key), action, [])
    Ets.upsert(%{key: key, value: value})
  end

  defp add_favorite_if_needed(jobs, user) when is_nil(user), do: jobs
  defp add_favorite_if_needed(jobs, user) do
    %{jobs | entries: add_favorite(jobs.entries, user)}
  end

  defp add_favorite(entries, user) when is_list(entries) do
    Enum.map(entries, &(add_favorite(&1, user)))
  end

  defp add_favorite(job, user) when is_nil(user), do: job

  defp add_favorite(%Job{} = job, user) do
    %Job{ job | favorited: FavoriteJobs.exists?(%{user_id: user.id, job_id: job.id})}
  end

  defp add_favorite(job, user) when is_map(job) do
    Enum.into(job, %{ favorited: FavoriteJobs.exists?(%{user_id: user.id, job_id: job.job_id})})
  end


end
