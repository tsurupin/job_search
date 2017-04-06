defmodule Customer.Web.JobTechKeywordTest do
  use Customer.Web.TestWithEcto, async: true

  alias Customer.Web.{JobTechKeywords, JobTechKeyword}
  alias Customer.Repo
  import Ecto.Query, only: [where: 2]
  setup [:create_job]

  test "user bulk_upserts", %{job: job} do

    job_tech_keyword1 = insert(:job_tech_keyword, job: job)
    job_tech_keyword2 = insert(:job_tech_keyword, job: job)
    tech_keyword = insert(:tech_keyword)
    result = JobTechKeywords.bulk_delete_and_upsert([job_tech_keyword1.tech_keyword_id, tech_keyword.id], job.id)
    |> Repo.transaction
    job_tech_keywords = JobTechKeyword |> where(job_id: ^job.id) |> Repo.all
    assert Enum.map(job_tech_keywords, &(&1.id)) == [job_tech_keyword1.id, tech_keyword.id]
  end

  test "user bulk_upserts with empty job_tech_keywords", %{job: job} do
    insert(:job_tech_keyword, job: job)
    JobTechKeywords.bulk_delete_and_upsert([], job.id)
    |> Repo.transaction
    job_tech_keywords = JobTechKeyword |> where(job_id: ^job.id) |> Repo.all
    assert Enum.map(job_tech_keywords, &(&1.id)) == []
  end

  test "user bulk_upserts with not existing job id" do
    import Ecto.Query, only: [where: 2]
    job = insert(:job)
    job_tech_keyword1 = insert(:job_tech_keyword, job: job)
    insert(:job_tech_keyword, job: job)
    assert {:error, _, _, _} = JobTechKeywords.bulk_delete_and_upsert([job_tech_keyword1.tech_keyword.id], job.id+1) |> Repo.transaction
  end

  def create_job(_context) do
    #import Ecto.Query, only: [where: 2]
    job = insert(:job)
    {:ok, %{job: job}}
  end

end
