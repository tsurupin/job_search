defmodule Customer.JobSourceTechKeyword do
  use Customer.Web, :model
  alias Customer.{TechKeyword, JobSource, JobSourceTechKeyword}

  schema "job_source_tech_keywords" do
    belongs_to :tech_keyword, TechKeyword
    belongs_to :job_source, JobSource

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [:tech_keyword_id, :job_source_id])
    |> validate_required([:tech_keyword_id, :job_source_id])
    |> unique_constraint(:tech_keyword_id, name: :job_source_tech_keywords_tech_keyword_id_job_source_id_index)
  end

  def by_keyword_ids_and_source_id(keyword_ids, source_id) do
    from j in JobSourceTechKeyword,
    where: not j.tech_keyword_id in ^keyword_ids and j.job_source_id == ^source_id
  end

end
