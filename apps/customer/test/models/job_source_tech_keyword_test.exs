defmodule Customer.Web.JobSourceTechKeywordTest do
  use Customer.Web.TestWithEcto, async: true

  alias Customer.Web.{JobSourceTechKeyword, JobSourceTechKeywords}
  import Ecto.Query, only: [where: 2]

  test "user fetches tech_keyword_ids_by" do
    job_source = insert(:job_source)
    assert JobSourceTechKeywords.tech_keyword_ids_by(job_source.id) == []
    job_source_tech_keyword = insert(:job_source_tech_keyword, job_source: job_source)
    assert JobSourceTechKeywords.tech_keyword_ids_by(job_source.id) == [job_source_tech_keyword.id]
  end

  test "user bulk_upserts" do
    job_source = insert(:job_source)
    job_source_tech_keyword1 = insert(:job_source_tech_keyword, job_source: job_source)
    insert(:job_source_tech_keyword, job_source: job_source)
    JobSourceTechKeywords.bulk_upsert!([job_source_tech_keyword1.tech_keyword.id], job_source.id)
    job_source_tech_keywords = JobSourceTechKeyword |> where(job_source_id: ^job_source.id) |> Repo.all
    assert Enum.map(job_source_tech_keywords, &(&1.id)) == [job_source_tech_keyword1.id]
  end

  test "user bulk_upserts with empty job_source_tech_keywords" do
    job_source1 = insert(:job_source)
    job_source2 = insert(:job_source)
    insert(:job_source_tech_keyword, job_source: job_source2)
    JobSourceTechKeywords.bulk_upsert([], job_source1.id) |> Repo.transaction
    job_source_tech_keywords = JobSourceTechKeyword |> where(job_source_id: ^job_source1.id) |> Repo.all
    assert Enum.map(job_source_tech_keywords, &(&1.id)) == []
  end

  test "user bulk_upserts with not existing job id" do
    job_source = insert(:job_source)
    job_source_tech_keyword1 = insert(:job_source_tech_keyword, job_source: job_source)
    insert(:job_source_tech_keyword, job_source: job_source)
    {:error, _, changeset, _} = JobSourceTechKeywords.bulk_upsert([job_source_tech_keyword1.tech_keyword.id], job_source.id+1) |> Repo.transaction

    {_key, {message, _}} = Enum.at(changeset.errors, 0)
    assert message == "does not exist"
  end

end
