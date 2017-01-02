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
  @required_fields ~w(company_id area_id title url)
  @optional_fields ~w(job_title detail)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def delete!(model) do
    Repo.transaction(fn ->
      Repo.delete! model
      Es.Document.delete_document model
    end)
  end

  # for elastic search

  def search_data(model) do
    model = Repo.get!(__MODULE__, model.id, preload: [:area, :company, :tech_keywords])
    [
      id: model.id,
      job_title: model.job_title,
      company_name: model.company.name,
      area_name: model.area.name,
      techs: Enum.map(model.tech_keywords, &(&1.name))
    ]
  end

  def es_reindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)

  def create_es_index(name \\ nil) do
    index = [type: estype, index: esindex(name)]
    Es.Schema.Job.completion(index)
  end


end
