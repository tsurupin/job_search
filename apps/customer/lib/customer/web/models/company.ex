defmodule Customer.Web.Company do
  use Customer.Web, :model

  schema "companies" do
    field :name, :string
    field :url, :string
    timestamps()

    has_many :jobs, Job, on_delete: :delete_all
    has_many :job_sources, JobSource, on_delete: :delete_all

  end

  @required_fields ~w(name url)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(company  \\ %__MODULE__{}, params \\ %{}) do
    cast(company, params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def build(%{name: name, url: url} = params) do
    changeset(%__MODULE__{}, params)
  end


end
