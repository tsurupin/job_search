defmodule Customer.JobSource do
  use Customer.Web, :model
  alias Customer.Repo
  alias Customer.{TechKeyword, Company, Area, JobSourceTechKeyword, JobSource}

  schema "job_sources" do
    many_to_many :tech_keywords, TechKeyword, join_through: JobSourceTechKeyword
    has_many :job_source_tech_keywords, JobSourceTechKeyword
    belongs_to :company, Company
    belongs_to :area, Area
    field :name, :string, virtual: true
    field :place, :string, virtual: true
    field :title
    field :job_title
    field :url
    field :detail
    field :source
    field :priority, :integer, default: 0

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def create_changeset(model \\ %__MODULE__{}, params \\ %{}) do
    changeset(model, params)
  end

  def update_changeset(model \\ %__MODULE__{}, params \\ %{}) do
    changeset(model, params)
  end

  def changeset(model \\ %__MODULE__{}, params \\ %{}) do
    model
    |> cast(params, ~w(title url detail source job_title area_id company_id))
    |> validate_required([:source, :title, :url, :area_id, :company_id])
    |> unique_constraint(:url)
    |> generate_priority
  end

  def find_or_initialize(url, title, source, area_id) do
    case Repo.get_by(JobSource, url: url, title: title, source: source, area_id: area_id) do
      nil -> %JobSource{}
      source -> source
    end
  end

  defp generate_priority(changeset) do
    priority =
      case changeset do
        "ycombinator" -> 300
        "admin" -> 1000
        _ -> 500
      end
    put_change(changeset, :priority, priority)
  end

end
