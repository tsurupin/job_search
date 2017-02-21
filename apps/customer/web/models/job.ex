defmodule Customer.Job do
  use Customer.Web, :model
  use Customer.Es
  alias Customer.Repo
  alias Customer.{TechKeyword, Company, Area, JobTechKeyword, UserInterest, JobTitle}

  schema "jobs" do
    many_to_many :tech_keywords, TechKeyword, join_through: JobTechKeyword
    has_many :job_tech_keywords, JobTechKeyword
    has_one :user_interest, UserInterest
    belongs_to :company, Company
    belongs_to :area, Area
    belongs_to :job_title, JobTitle
    field :url, :map
    field :title, :map
    field :detail, :map
    field :priority, :integer, virtual: true
    timestamps
  end

  @required_fields [:company_id, :area_id, :job_title_id, :title, :url]
  @optional_fields [:detail]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:area_id)
    |> foreign_key_constraint(:company_id)
  end

  def find_or_initialize_by(company_id, area_id, job_title_id) do
    case Repo.get_by(__MODULE__, company_id: company_id, area_id: area_id, job_title_id: job_title_id) do
      nil -> %__MODULE__{company_id: company_id, area_id: area_id, job_title_id: job_title_id}
      job -> job
    end
  end

  def delete!(model) do
    Repo.transaction(fn ->
      Repo.delete! model
      Es.Document.delete_document model
    end)
  end

  def get_with_associations!(id) do
    Repo.one!(from(j in __MODULE__, where: j.id == ^id, preload: [:area, :company, :tech_keywords, :job_title]))
  end

  def query_all(:index) do
    from j in __MODULE__,
    preload: [:area, :company, :tech_keywords, :job_title]
  end

  # for elastic search

  def es_search_data(model) do
    model = get_with_associations!(model.id)
    [
      job_id: model.id,
      job_title: String.downcase(model.job_title.name),
      detail: String.downcase(Map.get(model.detail, "value")),
      company_name: String.downcase(model.company.name),
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

  def es_search(params, options) do

    result =
      Tirexs.DSL.define fn ->
        opt = Es.Params.pager_option(options)

        build_default_query
        |> add_filter_query(params)
        |> add_sort_query(opt[:sort])
        |> es_logging
      end

    case result do
      {_, _, map} -> map
      r -> r
    end
  end

  defp build_default_query do
    import Tirexs.Search
    require Tirexs.Query.Filter
    search [index: esindex] do
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
