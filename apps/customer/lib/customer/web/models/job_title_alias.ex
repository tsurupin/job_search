defmodule Customer.Web.JobTitleAlias do
  use Customer.Web, :model

  schema "job_title_aliases" do
    field :name, :string
    timestamps

    belongs_to :job_title, JobTitle
  end

  @required_fields ~w(name job_title_id)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def build(params) do
    changeset(%__MODULE__{}, params)
  end

end
