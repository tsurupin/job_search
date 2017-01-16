defmodule Customer.JobSourceTechKeyword do
  use Customer.Web, :model
  alias Customer.Repo
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
    |> foreign_key_constraint(:tech_keyword_id)
    |> foreign_key_constraint(:job_source_id)
  end

  def tech_keyword_ids_by(job_source_id) do
    query_for_tech_keyword_ids(job_source_id)
    |> Repo.all
    |> Enum.map(&(&1.id))
  end

  defp query_for_tech_keyword_ids(job_source_id) do
    from(j in __MODULE__,
      where: j.job_source_id == ^job_source_id,
      select: map(j, [:id])
    )
  end

  def bulk_upsert!(tech_keyword_ids, job_source_id) do
    delete_if_needed!(tech_keyword_ids, job_source_id)
    Enum.each(tech_keyword_ids, &(upsert!(&1, job_source_id)))
  end

  defp delete_if_needed!(tech_keyword_ids, job_source_id) do
    by_source_id_except_tech_keyword_ids(tech_keyword_ids, job_source_id)
    |> Repo.delete_all
  end

  defp by_source_id_except_tech_keyword_ids(tech_keyword_ids, source_id) do
    from j in JobSourceTechKeyword,
    where: not j.tech_keyword_id in ^tech_keyword_ids and j.job_source_id == ^source_id
  end

  defp upsert!(tech_keyword_id, job_source_id) do
    record = Repo.get_by(__MODULE__, tech_keyword_id: tech_keyword_id, job_source_id: job_source_id) || %__MODULE__{}
    changeset(record, %{tech_keyword_id: tech_keyword_id, job_source_id: job_source_id})
    |> Repo.insert_or_update!
  end


end
