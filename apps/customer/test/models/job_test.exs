defmodule Customer.JobTest do
  use Customer.TestWithEcto, async: true

  alias Customer.Job

  test "find a persisted record" do
    company = insert(:company)
    insert(:job, company_id: company.id, job_title: "test")
    job = Job.find_or_initialize(company.id, "test")
    assert job.id !== nil
  end

  test "initialize a new record" do
    job = Job.find_or_initialize(company.id, "test")
    assert job.id == nil
  end

end
