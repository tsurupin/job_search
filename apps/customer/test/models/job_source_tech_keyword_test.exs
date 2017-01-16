defmodule Customer.JobSourceTechKeywordTest do
  use Customer.TestWithEcto, async: true

  alias Customer.JobSourceTechKeyword

  test "user fetches tech_keyword_ids_by" do
    job_source = insert(:job_source)
    assert JobSourceTechKeyword.tech_keyword_ids_by(job_source.id) == []
    job_source_tech_keyword = insert(:job_source_tech_keyword, job_source: job_source)
    assert JobSourceTechKeyword.tech_keyword_ids_by(job_source.id) == [job_source_tech_keyword.id]
  end

  test "user bulk_upserts" do
    import Ecto.Query, only: [where: 2]
    job_source = insert(:job_source)
    job_source_tech_keyword1 = insert(:job_source_tech_keyword, job_source: job_source)
    job_source_tech_keyword2 = insert(:job_source_tech_keyword, job_source: job_source)
    JobSourceTechKeyword.bulk_upsert!([job_source_tech_keyword1.tech_keyword.id], job_source.id)
    job_source_tech_keywords = JobSourceTechKeyword |> where(job_source_id: ^job_source.id) |> Repo.all
    assert Enum.map(job_source_tech_keywords, &(&1.id)) == [job_source_tech_keyword1.id]
  end

  test "user bulk_upserts with empty job_source_tech_keywords" do
    import Ecto.Query, only: [where: 2]
    job_source = insert(:job_source)
    insert(:job_source_tech_keyword, job_source: job_source)
    JobSourceTechKeyword.bulk_upsert!([], job_source.id)
    job_source_tech_keywords = JobSourceTechKeyword |> where(job_source_id: ^job_source.id) |> Repo.all
    assert Enum.map(job_source_tech_keywords, &(&1.id)) == []
  end

  test "user bulk_upserts with not existing job id" do
    import Ecto.Query, only: [where: 2]
    job_source = insert(:job_source)
    job_source_tech_keyword1 = insert(:job_source_tech_keyword, job_source: job_source)
    insert(:job_source_tech_keyword, job_source: job_source)
    assert_raise(Ecto.InvalidChangesetError, fn -> JobSourceTechKeyword.bulk_upsert!([job_source_tech_keyword1.tech_keyword.id], job_source.id+1) end)
  end

end
