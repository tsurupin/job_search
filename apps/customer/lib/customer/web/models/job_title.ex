defmodule Customer.Web.JobTitle do
  use Customer.Web, :model

  schema "job_titles" do
    field :name, :string
    timestamps()

    has_many :job_title_aliases, JobTitleAlias
    has_many :jobs, Job
  end

  @required_fields ~w(name)a


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(job_title \\ %__MODULE__{}, params \\ %{}) do
    cast(job_title, params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def build(params) do
    changeset(%__MODULE__{}, params)
  end


end
