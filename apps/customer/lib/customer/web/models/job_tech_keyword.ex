defmodule Customer.Web.JobTechKeyword do
  use Customer.Web, :model

  schema "job_tech_keywords" do
    timestamps()

    belongs_to :tech_keyword, TechKeyword
    belongs_to :job, Job
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @required_fields ~w(tech_keyword_id job_id)a

  def changeset(job_tech_keyword, params \\ %{}) do
    cast(job_tech_keyword, params, @required_fields)
    |> unique_constraint(:tech_keyword_id, name: :job_tech_keywords_tech_keyword_id_job_id_index)
    |> foreign_key_constraint(:tech_keyword_id)
    |> foreign_key_constraint(:job_id)
  end

  def build(params) do
    changeset(%__MODULE__{}, params)
  end

  def update(job_tech_keyword, params) do
    changeset(job_tech_keyword, params)
  end


end
