defmodule Customer.JobTechKeyword do
  use Customer.Web, :model
  alias Customer.Repo
  alias Customer.{TechKeyword, Job}


  schema "job_tech_keywords" do
    belongs_to :tech_keyword, TechKeyword
    belongs_to :job, Job

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @required_fields ~w(tech_keyword_id job_id)a

  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> unique_constraint(:tech_keyword_id, name: :job_tech_keywords_tech_keyword_id_job_id_index)
    |> foreign_key_constraint(:tech_keyword_id)
    |> foreign_key_constraint(:job_id)
  end

  def bulk_upsert!(tech_keyword_ids, job_id) do
    delete_if_needed!(tech_keyword_ids, job_id)
    Enum.each(tech_keyword_ids, &(upsert!(&1, job_id)))
  end

  def by_job_id(job_id) do
    from(j in __MODULE__, where: j.job_id == ^ job_id)
  end

  defp delete_if_needed!(tech_keyword_ids, job_id) do
    by_job_id_except_tech_keyword_ids(tech_keyword_ids, job_id)
    |> Repo.delete_all
  end

  defp by_job_id_except_tech_keyword_ids(tech_keyword_ids, job_id) do
    from(j in by_job_id(job_id), where: not j.tech_keyword_id in ^tech_keyword_ids)
  end

  defp upsert!(tech_keyword_id, job_id) do
    record = Repo.get_by(__MODULE__, tech_keyword_id: tech_keyword_id, job_id: job_id) || %__MODULE__{}
    changeset(record, %{tech_keyword_id: tech_keyword_id, job_id: job_id})
    |> Repo.insert_or_update!
  end

end
