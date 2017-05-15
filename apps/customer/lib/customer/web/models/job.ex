defmodule Customer.Web.Job do
  use Customer.Web, :model
  use Customer.Es
  alias Customer.Web.Query

  schema "jobs" do
    field :url, :map
    field :title, :map
    field :detail, :map
    field :priority, :integer, virtual: true
    field :favorited, :boolean, virtual: true
    timestamps()

    many_to_many :tech_keywords, TechKeyword, join_through: JobTechKeyword
    has_many :job_tech_keywords, JobTechKeyword
    has_many :favorite_jobs, FavoriteJob
    has_many :job_applications, JobApplication
    belongs_to :company, Company
    belongs_to :area, Area
    belongs_to :job_title, JobTitle
  end

  @required_fields ~w(company_id area_id job_title_id title url)a
  @optional_fields ~w(detail)a
  @associated_tables [:area, :company, :tech_keywords, :job_title]
  @default_options %{sort: "desc"}

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(job \\ %__MODULE__{}, params \\ %{}) do
    cast(job, params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:area_id)
    |> foreign_key_constraint(:company_id)
    |> foreign_key_constraint(:job_title_id)
  end

  def build(params) do
    changeset(%__MODULE__{}, params)
  end

  def build(params, job_source) do
    changeset(%__MODULE__{}, update_attributes(struct(%__MODULE__{}, params), job_source))
  end

  def update(job, job_source) do
    changeset(job, update_attributes(job, job_source))
  end

  defp update_attributes(%__MODULE__{area_id: area_id, company_id: company_id, job_title_id: job_title_id, url: url, title: title, detail: detail} = params, job_source) do
    Map.take(params, ~w(company_id area_id job_title_id)a)
    |> update_map_attribute(url, :url, job_source)
    |> update_map_attribute(title, :title, job_source)
    |> update_map_attribute(detail, :detail, job_source)
   end

  defp update_map_attribute(attributes, attribute, column_name, job_source) do
    if attribute == nil || Map.get(attribute, "priority") <= job_source.priority do
      Map.put_new(
        attributes,
        column_name,
        %{
          "value" => Map.get(job_source, column_name),
          "priority" => job_source.priority,
          "job_source_id" => job_source.id
        }
      )
    else
      attributes
    end
  end


  ################ ElasticSearch ################

  def es_search_data(model) do
    model = Query.Job.get_with_associations(Repo, model.id)
    [
      job_id: model.id,
      job_title: String.downcase(model.job_title.name),
      title: Map.get(model.title, "value"),
      detail: String.downcase(Map.get(model.detail, "value")),
      company_name: model.company.name,
      area: String.downcase(model.area.name),
      techs: Enum.map(model.tech_keywords, &(String.downcase(&1.name))),
      updated_at: Timex.format!(model.updated_at, "%Y-%m-%d", :strftime)
    ]
  end

  def es_reindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)

  def es_create_index(name \\ nil) do
    index = [type: estype, index: esindex(name)]
    Es.Schema.Job.completion(index)
  end

  def es_search, do: es_search(nil, [])
  def es_search(params), do: es_search(params, [])
  def es_search(params, options) when params == %{},  do: es_search(nil, options)

  def es_search(params, options \\ %{page: 1}) do
    options = Map.merge(@default_options, options)
    result =
      Tirexs.DSL.define fn ->
        opt = Es.Params.pager_option(options)

        build_default_query(Map.take(opt, [:per_page, :offset]))
        |> add_filter_query(params)
        |> add_sort_query(opt[:sort])
        |> es_logging
      end

    case result do
      {_, _, map} -> map
      r -> r
    end
  end

  defp build_default_query(%{per_page: per_page, offset: offset}) do
    import Tirexs.Search
    require Tirexs.Query.Filter
    search [index: esindex, from: offset, size: per_page] do
      query do
        filtered do
          query do
            match_all([])
          end
        end
      end
    end
  end


  defp add_filter_query(query, nil), do: query
  defp add_filter_query(query, params) do
     put_in query, [:search, :query, :filtered, :filter], Es.Filter.Job.perform(params)
  end

  defp add_sort_query(query, nil), do: query
  defp add_sort_query(query, sort) do
     put_in query, [:search, :sort], Es.Sort.perform(sort)
  end

  defp es_logging(query) do
    Es.Logger.ppdebug(query)
    query
  end

end
