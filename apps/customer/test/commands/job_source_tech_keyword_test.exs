defmodule Customer.Web.Command.JobSourceTechKeywordTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Command
  alias Customer.Repo
  alias Customer.Web.JobSourceTechKeyword

 describe "bulk_delete_and_upsert" do
   test "create job_source_tech_keywords" do
    job_source1 = insert(:job_source)
    job_source2 = insert(:job_source)
    tech_keyword = insert(:tech_keyword)
    job_source_tech_keyword1 = insert(:job_source_tech_keyword, job_source: job_source1)
    multi = Command.JobSourceTechKeyword.bulk_delete_and_upsert([tech_keyword.id], job_source2.id)
    assert {:ok, _data} = Repo.transaction(multi)
    refute Repo.get(JobSourceTechKeyword, job_source_tech_keyword1.id) == nil
    refute Repo.get_by(JobSourceTechKeyword, tech_keyword_id: tech_keyword.id) == nil
   end

   test "update job_source_tech_keywords" do
     job_source = insert(:job_source)
     tech_keyword = insert(:tech_keyword)

     job_source_tech_keyword = insert(:job_source_tech_keyword, job_source: job_source, tech_keyword: tech_keyword)
     multi = Command.JobSourceTechKeyword.bulk_delete_and_upsert([tech_keyword.id], job_source.id)
     assert {:ok, _data} = Repo.transaction(multi)
     new_job_source_tech_keyword = Repo.get(JobSourceTechKeyword, job_source_tech_keyword.id)
     refute new_job_source_tech_keyword.updated_at > job_source_tech_keyword.updated_at
   end

   test "delete existing job_source_tech_keywords and create new job_source_tech_keywords" do
     job_source = insert(:job_source)
     tech_keyword = insert(:tech_keyword)
     job_source_tech_keyword1 = insert(:job_source_tech_keyword, job_source: job_source)
     multi = Command.JobSourceTechKeyword.bulk_delete_and_upsert([tech_keyword.id], job_source.id)
     assert {:ok, _data} = Repo.transaction(multi)
     assert Repo.get(JobSourceTechKeyword, job_source_tech_keyword1.id) == nil
     refute Repo.get_by(JobSourceTechKeyword, tech_keyword_id: tech_keyword.id) == nil
   end
 end
end
