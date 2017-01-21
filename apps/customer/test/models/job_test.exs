defmodule Customer.JobTest do
  use Customer.TestWithEcto, async: true

  alias Customer.Job

  test "find a persisted record" do
    job = insert(:job, job_title: "test")
    job = Job.find_or_initialize_by(job.company_id, "test")
    assert job.id !== nil
  end

  test "initialize a new record" do
    company = insert(:company)
    job = Job.find_or_initialize_by(company.id, "test")
    assert job.id == nil
  end



end
