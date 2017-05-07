defmodule Customer.Web.JobSourceTechKeyword do
  use Customer.Web, :model

  schema "job_source_tech_keywords" do
    belongs_to :tech_keyword, TechKeyword
    belongs_to :job_source, JobSource

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(job_source_tech_keyword \\ %__MODULE__{}, params \\ %{}) do
    cast(job_source_tech_keyword, params, [:tech_keyword_id, :job_source_id])
    |> validate_required([:tech_keyword_id, :job_source_id])
    |> unique_constraint(:tech_keyword_id, name: :job_source_tech_keywords_tech_keyword_id_job_source_id_index)
    |> foreign_key_constraint(:tech_keyword_id)
    |> foreign_key_constraint(:job_source_id)
  end


  def build(params) do
    changeset(%__MODULE__{}, params)
  end

  def update(job_source_tech_keyword, params) do
    changeset(job_source_tech_keyword, params)
  end

end
