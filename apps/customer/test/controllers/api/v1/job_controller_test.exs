defmodule Customer.Api.V1.JobControllerTest do
  use Customer.ConnCase, async: true

  alias Customer.Job

  describe "index" do
    setup do
      job_title1 = insert(:job_title, name: "test1")
      job_title2 = insert(:job_title, name: "test2")
      area1 = insert(:area, name: "San Francisco")
      area2 = insert(:area, name: "Seattle")

      tech_keyword1 = insert(:tech_keyword, name: "rails")
      tech_keyword2 = insert(:tech_keyword, name: "elixir")

      job1 = insert(:job, area: area1, job_title: job_title1, detail: %{"value": "detail1"})
      job2 = insert(:job, area: area2, job_title: job_title2, detail: %{"value": "detail2"})

      insert(:job_tech_keyword, tech_keyword: tech_keyword1, job: job1)
      insert(:job_tech_keyword, tech_keyword: tech_keyword2, job: job2)

      Job.es_reindex
    end

    test "get jobs and job_titles and areas" do

    end

    test "get jobs and job_titles and areas with page 2" do

    end
  end

  describe "show" do

    setup do
      job_title = insert(:job_title)
      area = insert(:area)
      company = insert(:company)
      tech_keyword = insert(:tech_keyword)
      job = insert(:job, company: company, area: area, job_title: job_title, detail: %{"value": "detail"})
      insert(:job_tech_keyword, tech_keyword: tech_keyword, job: job)
      {:ok, job_title: job_title, area: area, tech_keyword: tech_keyword, job: job, company: company}
    end

    test "get a job", j do
      conn = get build_conn(), "api/v1/jobs/#{j.job.id}"
      assert conn.status == 200
      result = %{
        id: j.job.id,
        area: j.area.name,
        jobTitle: j.job_title.name,
        techKeywords: Enum.map(j.tech_keywords, &(%{id: &1.id, name: &1.name})),
        company: %{id: j.company.id, name: j.company.name},
        updatedAt: j.job.updated_at,
        detail: j.job.detail["value"]
       }
      body = Poison.decode!(conn.resp_body)
      assert body == result
    end

    test "get an error message" do

    end
  end


end