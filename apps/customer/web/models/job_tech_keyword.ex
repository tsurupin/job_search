defmodule Customer.JobTechKeyword do
  use Customer.Web, :model
  alias Customer.{TechKeyword, Job}

  schema "job_tech_keywords" do
    belongs_to :tech_keyword, TechKeyword
    belongs_to :job, Job

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct \\ %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [:tech_keyword_id, :job_id])
    |> validate_required([:tech_keyword_id, :job_id])
    |> unique_constraint(:tech_keyword_id, name: :job_tech_keywords_tech_keyword_id_job_id_index)
  end

end
