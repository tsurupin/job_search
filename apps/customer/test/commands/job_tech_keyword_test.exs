defmodule Customer.Web.Command.JobTechKeywordTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Command
  alias Customer.Repo
  alias Customer.Web.JobTechKeyword

  describe "bulk_delete_and_upsert" do
    test "create job_tech_keywords" do
     job1 = insert(:job)
     job2 = insert(:job)
     tech_keyword = insert(:tech_keyword)
     job_tech_keyword1 = insert(:job_tech_keyword, job: job1)
     multi = Command.JobTechKeyword.bulk_delete_and_upsert([tech_keyword.id], job2.id)
     assert {:ok, _data} = Repo.transaction(multi)
     refute Repo.get(JobTechKeyword, job_tech_keyword1.id) == nil
     refute Repo.get_by(JobTechKeyword, tech_keyword_id: tech_keyword.id) == nil
    end

    test "update job_tech_keywords" do
      job = insert(:job)
      tech_keyword = insert(:tech_keyword)

      job_tech_keyword = insert(:job_tech_keyword, job: job, tech_keyword: tech_keyword)
      multi = Command.JobTechKeyword.bulk_delete_and_upsert([tech_keyword.id], job.id)
      assert {:ok, _data} = Repo.transaction(multi)
      new_job_tech_keyword = Repo.get(JobTechKeyword, job_tech_keyword.id)
      refute new_job_tech_keyword.updated_at > job_tech_keyword.updated_at
    end

    test "delete existing job_tech_keywords and create new job_tech_keywords" do
      job = insert(:job)
      tech_keyword = insert(:tech_keyword)
      job_tech_keyword1 = insert(:job_tech_keyword, job: job)
      multi = Command.JobTechKeyword.bulk_delete_and_upsert([tech_keyword.id], job.id)
      assert {:ok, _data} = Repo.transaction(multi)
      assert Repo.get(JobTechKeyword, job_tech_keyword1.id) == nil
      refute Repo.get_by(JobTechKeyword, tech_keyword_id: tech_keyword.id) == nil
    end
  end

end
