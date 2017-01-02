defmodule Customer.TechKeyword do
  use Customer.Web, :model
  use Customer.Es
  alias Customer.{TechKeyword, JobTechKeyword, JobSourceTechKeyword, Repo}

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

  def delete!(model) do
    Repo.transaction(fn ->
      Repo.delete! model
      Es.Document.delete_document model
    end)
  end

  def by_names(names) do
    from k in TechKeyword,
    where: k.name in ^names
  end

  # for elastic search

  def es_search_data(record) do
    [
      id: record.id,
      name: record.name
    ]
  end

  def es_reindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)

  def es_create_index(name \\ nil) do
    index = [type: estype, index: esindex(name)]
    Es.Schema.TechKeyword.completion(index)
  end
end
