defmodule Customer.Job do
  use Customer.Web, :model
  alias Customer.{TechKeyword, Company, Area, JobTechKeyword}

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
end
