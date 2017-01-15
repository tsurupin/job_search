defmodule Customer.Job do
  use Customer.Web, :model
  use Customer.Es
  alias Customer.Repo
  alias Customer.{TechKeyword, Company, Area, Job, JobTechKeyword, UserInterest}

  schema "jobs" do
    many_to_many :tech_keywords, TechKeyword, join_through: JobTechKeyword
    has_many :job_tech_keywords, JobTechKeyword
    has_one :user_interest, UserInterest
    belongs_to :company, Company
    belongs_to :area, Area
    field :title, :string
    field :job_title, :string
    field :url, :string
    field :detail, :string

    timestamps
  end
  @required_fields [:company_id, :area_id, :title, :url]
  @optional_fields [:job_title, :detail]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def find_or_initialize(company_id, job_title) do
    case Repo.get_by(Job, company_id: company_id, job_title: job_title) do
      nil -> %Job{}
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
    Repo.get!(__MODULE__, id, preload: [:area, :company, :tech_keywords])
  end


  # for elastic search

  def es_search_data(model) do
    model = get_with_associations!(model.id)
    [
      id: model.id,
      job_title: model.job_title,
      detail: model.detail,
      company_name: model.company.name,
      area_name: model.area.name,
      techs: Enum.map(model.tech_keywords, &(&1.name)),
      updated_at: model.updated_at
    ]
  end

  def es_reindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)

  def es_create_index(name \\ nil) do
    index = [type: estype, index: esindex(name)]
    Es.Schema.Job.completion(index)
  end

  def es_search, do: es_search(nil, [])
  def es_search(params), do: es_search(params, [])
  def es_search("", options), do: es_search(nil, options)

  def es_search(params, options) do
    result =
      Tirexs.DSL.define fn ->
        opt = Es.Params.pager_option(options)
        offset = opt[:offset]
        per_page = opt[:per_page]

        build_default_query(offset, per_page)
        |> add_filter_query(params)
        |> add_sort_query(opt[:sort])
        |> es_logging
      end

    case result do
      {_, _, map} -> map
      r -> r
    end
  end

  defp build_default_query(offset, per_page) do
    import Tirexs.Search
    import Tirexs.Query
    require Tirexs.Query.Filter
    search [index: esindex, fields: [], from: offset, size: per_page] do
      query do
        filtered do
          query do
            match_all([])
          end
        end
      end
    end
  end

  defp add_filter_query(query, params) when is_nil(params), do: query
  defp add_filter_query(query, params) do
     put_in query, [:search, :query, :filtered, :filter], Es.Filter.Job.perform(params)
  end

  defp add_sort_query(query, sort) when is_nil(sort), do: query
  defp add_sort_query(query, sort) do
     put_in query, [:search, :sort], Es.Sort.perform(%{updated_at: :desc})
  end

  defp es_logging(query) do
    Es.Logger.ppdebug(query)
    query
  end

end
