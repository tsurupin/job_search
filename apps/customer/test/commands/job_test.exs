defmodule Customer.Web.Command.JobTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Command
  alias Customer.Repo
  alias Customer.Web.{Job, JobSource}

  describe "upsert" do
#    test "returns update multi" do
#      company = insert(:company)
#      job_title = insert(:job_title)
#      area = insert(:area)
#      params = struct(JobSource, %{company_id: company.id, job_title: job_title.name, area_id: area.id})
#
#      job = insert(:job, company: company, area: area, job_title: job_title, updated_at: Timex.to_datetime({{2016,2,8}, {12,0,0}}))
#
#      multi = Command.Job.upsert(params, job_title.id)
#
#      assert {:ok, data} = Repo.transaction(multi)
#      assert data.job.updated_at > job.updated_at
#    end

    test "returns insert multi" do
      company = insert(:company)
      job_title = insert(:job_title)
      area = insert(:area)
      params = struct(JobSource, %{company_id: company.id, job_title: job_title.name, area_id: area.id})

      multi = Command.Job.upsert(params, job_title.id)
      assert {:ok, data} = Repo.transaction(multi)
      refute data.job.id == nil
    end
  end

end
