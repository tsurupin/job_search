defmodule Customer.Area do
  use Customer.Web, :model
  use Customer.Es
  alias Customer.Repo
  alias Customer.{Job, JobSource, State, Area, Repo}

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
    |> cast(params, [])
    |> validate_required([])
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

  # for elastic search

  def search_data(record) do
    [
      id: record.id,
      name: record.name
    ]
  end

  def es_reindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)

  def create_es_index(name \\ nil) do
    index = [type: estype, index: esindex(name)]
    Es.Schema.Area.completion(index)
  end

end
