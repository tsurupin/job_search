defmodule Customer.Web.Area do
  use Customer.Web, :model

  schema "areas" do
    field :name
    timestamps()

    has_many :jobs, Job
    has_many :job_sources, JobSource
    belongs_to :state, State
  end

  @required_fields ~w(name state_id)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(area  \\ %__MODULE__{}, params \\ %{}) do
    cast(area, params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name, name: :area_name_state_id_unique_index)
    |> foreign_key_constraint(:state_id)
  end

  def build(%{state_id: state_id, name: name} = params) do
    changeset(%__MODULE__{}, params)
  end

end
