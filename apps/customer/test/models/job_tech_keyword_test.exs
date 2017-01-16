defmodule Customer.JobTechKeywordTest do
  use Customer.TestWithEcto, async: true

  alias Customer.JobTechKeyword

  test "user bulk_upserts" do
    import Ecto.Query, only: [where: 2]
    job = insert(:job)
    job_tech_keyword1 = insert(:job_tech_keyword, job: job)
    job_tech_keyword2 = insert(:job_tech_keyword, job: job)
    JobTechKeyword.bulk_upsert!([job_tech_keyword1.tech_keyword.id], job.id)
    job_tech_keywords = JobTechKeyword |> where(job_id: ^job.id) |> Repo.all
    assert Enum.map(job_tech_keywords, &(&1.id)) == [job_tech_keyword1.id]
  end

  test "user bulk_upserts with empty job_tech_keywords" do
    import Ecto.Query, only: [where: 2]
    job = insert(:job)
    insert(:job_tech_keyword, job: job)
    JobTechKeyword.bulk_upsert!([], job.id)
    job_tech_keywords = JobTechKeyword |> where(job_id: ^job.id) |> Repo.all
    assert Enum.map(job_tech_keywords, &(&1.id)) == []
  end

  test "user bulk_upserts with not existing job id" do
    import Ecto.Query, only: [where: 2]
    job = insert(:job)
    job_tech_keyword1 = insert(:job_tech_keyword, job: job)
    insert(:job_tech_keyword, job: job)
    assert_raise(Ecto.InvalidChangesetError, fn -> JobTechKeyword.bulk_upsert!([job_tech_keyword1.tech_keyword.id], job.id+1)end)
  end

end
