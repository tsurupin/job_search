defmodule Customer.Company do
  use Customer.Web, :model

  schema "companies" do
    field :name, :string
    field :url, :string
    timestamps()

    has_many :jobs, Job, on_delete: :delete_all
    has_many :job_sources, JobSource, on_delete: :delete_all

  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(company  \\ %__MODULE__{}, params \\ %{}) do
    cast(company, params, ~w(name url))
    |> validate_required(~w(name url)a)
  end

  def build(%{name: name, url: url} = params) do
    changeset(%__MODULE__{}, params)
  end


end
