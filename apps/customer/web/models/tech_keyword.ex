defmodule Customer.TechKeyword do
  use Customer.Web, :model
  use Customer.Es
  alias Customer.Repo
  alias Customer.{TechKeyword, JobTechKeyword, JobSourceTechKeyword}

  schema "tech_keywords" do
    has_many :job_source_tech_keywords, JobSourceTechKeyword
    has_many :job_tech_keywords, JobTechKeyword
    field :type, :string
    field :name, :string

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
    from t in __MODULE__,
    where: t.name in ^names
  end

  def pluck(query \\ __MODULE__, column) do
    from(t in query, select: map(t, [column]))
    |> Repo.all
    |> Enum.map(&(&1[column]))
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

  def es_search(word) when is_nil(word), do: nil
  def es_search(word) do
    word = String.downcase(word)
    result =
      Tirexs.DSL.define fn ->
        import Tirexs.Search
        import Tirexs.Query
        require Tirexs.Query.Filter
        search [index: esindex] do
          query do
            filtered do
              query do
                match_all([])
              end
              # filter do
              #   term "name", word
              # end
            end
          end
        end
      end

    case result do
      {_, _, map} -> map
      r -> r
    end
  end

end
