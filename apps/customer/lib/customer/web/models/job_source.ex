defmodule Customer.Web.JobSource do
  use Customer.Web, :model

  schema "job_sources" do
    field :name, :string, virtual: true
    field :place, :string, virtual: true
    field :job_title, :string
    field :title, :string
    field :url, :string
    field :detail, :string
    field :source, :string
    field :priority, :integer, default: 0

    timestamps()

    many_to_many :tech_keywords, TechKeyword, join_through: JobSourceTechKeyword
    has_many :job_source_tech_keywords, JobSourceTechKeyword
    belongs_to :company, Company
    belongs_to :area, Area
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  @required_fields ~w(company_id area_id title source url)a
  @optional_fields ~w(detail job_title)a

  def changeset(job_source \\ %__MODULE__{}, params \\ %{}) do
    cast(job_source, params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:url)
    |> foreign_key_constraint(:area_id)
    |> foreign_key_constraint(:company_id)
    |> generate_priority
  end

  def build(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end

  def update(job_source, params \\ %{}) do
    changeset(job_source, params)
  end

  defp generate_priority(changeset) do
    with {:ok, source} <- fetch_change(changeset, :source),
      priority <- priority(source)
    do
      put_change(changeset, :priority, priority)
    else
      _ -> put_change(changeset, :priority, 500)
    end
  end

  defp priority(source) do
    case source do
      "ycombinator" -> 300
      "admin" -> 1000
       _ -> 500
    end
  end

end
