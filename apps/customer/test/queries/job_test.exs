defmodule Customer.Web.Query.JobTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Query
  alias Customer.Repo

  describe "get_with_associations" do

    test "return a record" do
      job = insert(:job)
      record = Query.Job.get_with_associations(Repo, job.id)
      assert record.id == job.id
      refute record.area == nil
    end

    test "return nil" do
      record = Query.Job.get_with_associations(Repo, 1)
      assert record == nil
    end

  end

  describe "all_by_company_id" do
    test "return records" do
      company = insert(:company)
      job1 = insert(:job, company: company)
      job2 = insert(:job)
      records = Query.Job.all_by_company_id(Repo, company.id)
      assert Enum.map(records, &(&1.id)) == [job1.id]
    end

    test "return nil" do
      record = Query.Job.all_by_company_id(Repo, 1)
      assert record == []
    end

  end

end
