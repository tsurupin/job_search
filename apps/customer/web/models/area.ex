defmodule Customer.Area do
  use Customer.Web, :model
  alias Customer.Repo
  alias Customer.{Job, JobSource, State, Area, Repo}
  alias Customer.Es

  schema "areas" do
    has_many :jobs, Job
    has_many :job_sources, JobSource
    belongs_to :state, State
    field :name

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct  \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [:name, :state_id])
    |> validate_required([:name, :state_id])
  end

  def delete!(model) do
    Repo.transaction(fn ->
      Repo.delete! model
      Es.Document.delete_document model
    end)
  end

  def find_from!(place) do
    [area_name, state_abbreviation, _country] = area_and_state(place)
    state = Repo.get_by!(State, %{abbreviation: state_abbreviation})
    Repo.get_by!(Area, %{state_id: state.id, name: area_name})
  end

  defp area_and_state(place) do
    place
    |> String.split(",")
    |> Enum.map(&(String.trim(&1)))
  end

end
