defmodule Customer.Company do
  use Customer.Web, :model
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

  def delete!(model) do
    Repo.transaction(fn ->
      Repo.delete! model
      Es.Document.delete_document model
    end)
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

end
