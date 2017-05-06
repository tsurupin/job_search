defmodule Customer.Web.Query.JobTechKeywordTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Query
  alias Customer.Repo

  describe "by_job_id" do
    test "returns job tech keywords" do
      job = insert(:job)
      job_tech_keyword1 = insert(:job_tech_keyword, job: job)
      job_tech_keyword2 = insert(:job_tech_keyword)
      records =  Query.JobTechKeyword.all_by_job_id(Repo, job.id)
      assert Enum.map(records, &(&1.id)) == [job_tech_keyword1.id]
    end
  end

  describe "all_by_job_id_except_tech_keyword_ids" do
    test "returns job tech keywords" do
      job = insert(:job)
      job_tech_keyword1 = insert(:job_tech_keyword, job: job)
      job_tech_keyword2 = insert(:job_tech_keyword, job: job)
      job_tech_keyword3 = insert(:job_tech_keyword)
      records =  Repo.all(Query.JobTechKeyword.by_job_id_except_tech_keyword_ids(job.id, [job_tech_keyword2.id]))
      assert Enum.map(records, &(&1.id)) == [job_tech_keyword1.id]
    end
  end


end
