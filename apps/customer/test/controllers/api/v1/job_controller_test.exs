defmodule Customer.Web.Api.V1.JobControllerTest do
  use Customer.Web.ConnCase, async: true

  alias Customer.Web.{Job, FavoriteJobs}
  alias Customer.Repo
  alias Customer.Web.Query

  describe "index with login" do
    setup [:login, :first_page_setup]

    test "get jobs with favorited and job_titles and areas", j do
       job = Repo.get(Job, Keyword.get(Enum.at(j.jobs, 1), :job_id))
       insert(:favorite_job, user: j.user, job: job)

       conn = build_conn()
         |> put_req_header("authorization", "Bearer #{j.jwt}")
         |> get(job_path(conn, :index))

       assert conn.status == 200
       body = Poison.decode!(conn.resp_body)
       result =
       %{
         "jobs" => Enum.map(j.jobs, fn job ->
            build_job_attributes(job)
            |> add_favorite_if_needed(j.user)
          end),
         "jobTitles" =>  Enum.map(j.job_titles, &(String.capitalize(&1.name))),
         "areas" => Enum.map(j.areas, &(&1.name)),
         "hasNext" => false,
         "nextPage" => 2,
         "page" => 1,
         "total" => 2
        }

        assert body == result
    end
  end

  describe "index with page 1" do
    setup [:first_page_setup]

    test "get jobs and job_titles and areas", j do
      conn = get build_conn(), "api/v1/jobs?page=1"
      assert conn.status == 200
      body = Poison.decode!(conn.resp_body)
      result =
      %{
         "jobs" => Enum.map(j.jobs, &(build_job_attributes(&1))),
         "jobTitles" =>  Enum.map(j.job_titles, &(String.capitalize(&1.name))),
         "areas" => Enum.map(j.areas, &(&1.name)),
         "hasNext" => false,
         "nextPage" => 2,
         "page" => 1,
         "total" => 2
       }

       assert body == result
    end

    test "get jobs and job_titles and areas with job_title", j do
        conn = get build_conn(), "api/v1/jobs?page=1&job-title=test1"
        assert conn.status == 200
        body = Poison.decode!(conn.resp_body)
        result =
          %{
             "jobs" => [build_job_attributes(Enum.at(j.jobs, 1))],
             "jobTitles" =>  Enum.map(j.job_titles, &(String.capitalize(&1.name))),
             "areas" => Enum.map(j.areas, &(&1.name)),
             "hasNext" => false,
             "nextPage" => 2,
             "page" => 1,
             "total" => 1
           }
         assert body == result
      end
  end

  describe "index with page 2" do
    setup [:second_page_setup]

    test "get jobs and job_titles and areas" do
      conn = get build_conn(), "api/v1/jobs?page=2"
      assert conn.status == 200
      body = Poison.decode!(conn.resp_body)
      assert Enum.count(body["jobs"]) == 1
      assert body["nextPage"] == 3
      assert body["page"] == 2
    end
  end

  describe "show with login" do
    setup [:login, :show_page_setup]

     test "get a job with favorited", j do
        insert(:favorite_job, user: j.user, job: j.job)

        conn = build_conn()
          |> put_req_header("authorization", "Bearer #{j.jwt}")
          |> get(job_path(conn, :show, j.job.id))

        assert conn.status == 200
        body = Poison.decode!(conn.resp_body)
        %{
          "id" => id,
          "area" => area,
          "jobTitle" => jobTitle,
          "techKeywords" => techKeywords,
          "company" => company,
          "favorited" => favorited
         } = body
        assert id == j.job.id
        assert area == j.area.name
        assert jobTitle == j.job_title.name
        assert favorited = true
        assert techKeywords == Enum.map(j.tech_keywords, &(%{"id" => &1.id, "name" => &1.name}))
        assert company == %{"id" => j.company.id, "name" => j.company.name}
      end

  end

  describe "show" do
    setup [:show_page_setup]

    test "get a job", j do
      conn = get build_conn(), "api/v1/jobs/#{j.job.id}"
      assert conn.status == 200
      body = Poison.decode!(conn.resp_body)
      %{
        "id" => id,
        "area" => area,
        "jobTitle" => jobTitle,
        "title" => title,
        "techKeywords" => techKeywords,
        "company" => company,
        "url" => url,
        "detail" => detail
       } = body
      assert id == j.job.id
      assert area == j.area.name
      assert jobTitle == j.job_title.name
      assert title == j.job.title["value"]
      assert techKeywords == Enum.map(j.tech_keywords, &(%{"id" => &1.id, "name" => &1.name}))
      assert company == %{"id" => j.company.id, "name" => j.company.name}
      assert detail == j.job.detail["value"]
      assert url == j.job.url["value"]
    end

    test "get an error message", j do
      conn = get build_conn(), "api/v1/jobs/#{j.job.id + 1}"
      assert conn.status == 404
      result = %{
        "errorMessage" => "Not Found"
       }
      body = Poison.decode!(conn.resp_body)
      assert body == result

    end
  end

  defp build_job_attributes([job_id: id, job_title: job_title, title: title, detail: detail, company_name: company_name, area: area, techs: techs, updated_at: updated_at]) do
    %{
      "id" => id,
      "area" => String.capitalize(area),
      "companyName" => company_name,
      "jobTitle" => job_title,
      "title" => title,
      "detail" => detail,
      "techs" => Enum.map(techs, &(String.capitalize(&1))),
      "updatedAt" => updated_at
    }
  end

  defp add_favorite_if_needed(map, user) do
   favorited = Query.FavoriteJob.exists?(Repo, %{user_id: user.id, job_id: map["id"]})
   Enum.into(map, %{"favorited" => favorited})
  end

  def login(_context) do
    user = insert(:user)
    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)

    {:ok, %{user: user, jwt: jwt, claims: full_claims} }
  end

  defp first_page_setup(_context) do
    Customer.Ets.reset()
    IO.inspect "first_page!!!!"
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
    {:ok, job_titles: [job_title1, job_title2], areas: [area1, area2], jobs: Enum.map([job2, job1], &(Job.es_search_data(&1))) }
  end

  defp second_page_setup(_context) do
    job_title = insert(:job_title)
    area = insert(:area)
    Enum.each(1..21, fn _ -> insert(:job, area: area, job_title: job_title) end)
    Job.es_reindex
  end

  defp show_page_setup(_context) do
    job_title = insert(:job_title)
    area = insert(:area)
    company = insert(:company)
    tech_keyword = insert(:tech_keyword)
    job = insert(:job, company: company, area: area, job_title: job_title, detail: %{"value" => "detail"}, url: %{"value" => "http://google.com"})
    insert(:job_tech_keyword, tech_keyword: tech_keyword, job: job)
    {:ok, job_title: job_title, area: area, tech_keywords: [tech_keyword], job: job, company: company}
  end

end
