defmodule Customer.JobTitle do
  use Customer.Web, :model

  alias Customer.Repo
  alias Customer.{JobTitleAlias, Job}

  schema "job_titles" do
    has_many :job_title_aliases, JobTitleAlias
    has_many :jobs, Job
    field :name, :string
    timestamps
  end

  @required_fields ~w(name)a


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def names do
     (from j in __MODULE__, select: j.name)
     |> Repo.all
  end

end
