defmodule Customer.TechKeyword do
  use Customer.Web, :model
  alias Customer.{TechKeyword, JobTechKeyword, JobSourceTechKeyword}

  schema "tech_keywords" do
    has_many :job_source_tech_keywords, JobSourceTechKeyword
    has_many :job_tech_keywords, JobTechKeyword
    field :type
    field :name

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [:type, :name])
    |> validate_required([:type, :name])
    |> unique_constraint(:name)
  end

  def by_names(names) do
    from k in TechKeyword,
    where: k.name in ^names
  end

end
