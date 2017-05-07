defmodule Customer.Web.Command.JobSourceTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Command
  alias Customer.Repo

  describe "upsert" do
    test "update a record if record found" do
      company = insert(:company)
      area = insert(:area)
      job_source = insert(:job_source,
        url: "http://google.com",
        job_title: "job_title",
        source: "ycombinator",
        area: area,
        company: company
       )
      params = %{
        url: "http://google.com",
        job_title: "job_title",
        title: "title",
        source: "ycombinator",
        area_id: area.id,
        company_id: company.id,
        detail: "new_detail"
       }
       multi = Command.JobSource.upsert(params)
       assert {:ok, data} = Repo.transaction(multi)
       assert data.job_source.detail == "new_detail"
    end

    test "create a new record if record not found" do
       company = insert(:company)
       area = insert(:area)
        params = %{
          url: "http://google.com",
          job_title: "job_title",
          title: "title",
          source: "ycombinator",
          area_id: area.id,
          company_id: company.id
        }
       multi = Command.JobSource.upsert(params)
       assert {:ok, data} = Repo.transaction(multi)
       refute data.job_source.id == nil
    end

  end

end
