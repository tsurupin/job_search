defmodule Customer.Job do
  use Customer.Web, :model
  use Customer.Es
  alias Customer.{TechKeyword, Company, Area, JobTechKeyword, Repo}

  schema "jobs" do
    many_to_many :tech_keywords, TechKeyword, join_through: JobTechKeyword
    has_many :job_tech_keywords, JobTechKeyword
    belongs_to :company, Company
    belongs_to :area, Area
    field :title
    field :job_title
    field :url
    field :detail

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end

  # for elastic search

  def search_data(record) do
    record = Repo.get!(__MODULE__, record.id, preload: [:area, :company, :tech_keywords])
    [
      id: record.id,
      job_title: record.job_title,
      company_name: record.company.name,
      area_name: record.area.name,
      techs: Enum.map(record.tech_keywords, &(&1.name))
    ]
  end

  def es_reindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)

  def create_es_index(name \\ nil) do
    index = [type: estype, index: esindex(name)]
    Es.Schema.Job.completion(index)
  end
end
