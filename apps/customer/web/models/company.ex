defmodule Customer.Company do
  use Customer.Web, :model
  use Customer.Es
  alias Customer.Repo
  alias Customer.{Job, JobSource, Company, Repo}

  schema "companies" do
    field :name, :string
    field :url, :string

    has_many :jobs, Job, on_delete: :delete_all
    has_many :job_sources, JobSource, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct  \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [:name, :url])
    |> validate_required([:name, :url])
  end

  def find_or_create!(name, url) do
    case Repo.get_by(Company, name: name) do
      nil ->
        changeset = Company.changeset(%Company{}, %{name: name, url: url})
        company = Repo.insert!(changeset)
        company
      company ->
        company
    end
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
    Es.Schema.Company.completion(index)
  end
end
