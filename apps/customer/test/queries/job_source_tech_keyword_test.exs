defmodule Customer.Web.Query.JobSourceTechKeywordTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Query
  alias Customer.Repo

  describe "tech_keyword_ids_by" do
    test "returns tech_keywords_ids" do
      job_source = insert(:job_source)
      job_source_tech_keyword1 = insert(:job_source_tech_keyword, job_source: job_source)
      job_source_tech_keyword2 = insert(:job_source_tech_keyword)
      assert Query.JobSourceTechKeyword.tech_keyword_ids_by(Repo, job_source.id) == [job_source_tech_keyword1.tech_keyword_id]
    end
  end

  describe "by_job_source_id_except_tech_keyword_ids" do
    test "returns sql" do
      tech_keyword = insert(:tech_keyword)
      job_source = insert(:job_source)
      job_source_tech_keyword1 = insert(:job_source_tech_keyword, job_source: job_source, tech_keyword: tech_keyword)
      job_source_tech_keyword2 = insert(:job_source_tech_keyword, job_source: job_source)
      tech_keyword_ids = [tech_keyword.id]
      query = Query.JobSourceTechKeyword.by_job_source_id_except_tech_keyword_ids(tech_keyword_ids, job_source.id)

      assert Enum.map(Repo.all(query), &(&1.id)) == [job_source_tech_keyword2.id]
    end
  end

end
