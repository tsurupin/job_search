defmodule Customer.Web.Query.JobApplicationTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Query
  alias Customer.Repo

  describe "get_by_user_and_job_and_status" do
    test "return nil when no record found" do
      params = %{user_id: 1, job_id: 1, status: 1}
      record = Query.JobApplication.get_by_user_and_job_and_status(Repo, params)
      assert record == nil
    end

    test "return a record" do
      job_application = insert(:job_application, status: 1)
      params = %{user_id: job_application.user_id, job_id: job_application.job_id, status: 1}
      record = Query.JobApplication.get_by_user_and_job_and_status(Repo, params)
      assert record.id == job_application.id
    end

  end

  describe "latest" do
    test "return the latest record" do
      params = %{user_id: 1, job_id: 1}
      record = Query.JobApplication.latest(Repo, params)
      assert record == nil
    end

    test "return nil when no record found" do
      user = insert(:user)
      job = insert(:job)
      job_application1 = insert(:job_application, user: user, job: job, status: 1)
      # TODO: need to make difference by inserting different updated_at
      :timer.sleep(1000)
      job_application2 = insert(:job_application, user: user, job: job, status: 2)
      params = %{user_id: user.id, job_id: job.id}

      record = Query.JobApplication.latest(Repo, params)
      assert record.id == job_application2.id
    end
  end

end
