defmodule Customer.Web.TechKeyword do
  use Customer.Web, :model
  use Customer.Es
  alias Customer.Es

  schema "tech_keywords" do
    field :type, :string
    field :name, :string

    timestamps()

    has_many :job_source_tech_keywords, JobSourceTechKeyword
    has_many :job_tech_keywords, JobTechKeyword
  end

  @required_fields ~w(type name)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(tech_keyword \\ %__MODULE__{}, params \\ %{}) do
    cast(tech_keyword, params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end


 ################ ElasticSearch ################

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

  def es_search(nil), do: nil
  def es_search(word) do
    word = String.downcase(word)

    result =
      Tirexs.DSL.define fn ->
        import Tirexs.Search
        require Tirexs.Query.Filter
        search [index: esindex] do
          query do
            filtered do
              query do
                match_all([])
              end
              filter do
                term "name", word
              end
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
