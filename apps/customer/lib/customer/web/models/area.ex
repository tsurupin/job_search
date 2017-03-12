defmodule Customer.Web.Area do
  use Customer.Web, :model

  schema "areas" do
    field :name
    timestamps()

    has_many :jobs, Job
    has_many :job_sources, JobSource
    belongs_to :state, State
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(area  \\ %__MODULE__{}, params \\ %{}) do
    cast(area, params, ~w(name state_id))
    |> validate_required(~w(name state_id)a)
  end

  def names do
    (from a in __MODULE__, select: a.name)
  end


end
