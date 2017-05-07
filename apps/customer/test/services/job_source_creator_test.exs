defmodule Customer.Web.Service.JobSourceCreatorTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Service.JobSourceCreator
  alias Customer.Web.{JobSource, Company, JobSourceTechKeyword, Job, JobTechKeyword, JobTitleAlias, JobTitle}
  alias Customer.Web.Query
  alias Customer.Web.Command

  test "creates a job source" do
    state = insert(:state, abbreviation: "CA")
    insert(:area, state: state, name: "San Francisco")
    keyword1 = insert(:tech_keyword, name: "keyword1")
    keyword2 = insert(:tech_keyword, name: "keyword2")
    params = %{
      name: "new company",
      place: "San Francisco, CA, USA",
      url: "http://google.com",
      title: "hoge",
      job_title: "hoge",
      source: "Sequoia",
      keywords: [keyword1.name, keyword2.name]
    }
    JobSourceCreator.perform(params)

    job_source = Repo.one(from j in JobSource, preload: [:tech_keywords, :company, :area])
    assert job_source.title == "hoge"
    assert Enum.map(job_source.tech_keywords, &(&1.name)) == [keyword1.name, keyword2.name]
    assert job_source.company.name == "new company"
    assert job_source.area.name == "San Francisco"
    assert Repo.aggregate(JobTitle, :count, :id) == 1
    assert Repo.aggregate(JobTitleAlias, :count, :id) == 1
    assert Repo.aggregate(Job, :count, :id) == 1
    assert Repo.aggregate(JobTechKeyword, :count, :id) == 2
  end

  test "updates job source" do
    company = insert(:company)
    state = insert(:state, abbreviation: "CA")
    area = insert(:area, state: state, name: "San Francisco")
    job_title = insert(:job_title, name: "job_title")
    job_title_alias = insert(:job_title_alias, job_title: job_title, name: "job title")
    job_source = insert(:job_source, url: "http://google.com", title: "hoge", job_title: "job title", source: "Sequoia", area: area, company: company)
    keyword1 = insert(:tech_keyword)
    keyword2 = insert(:tech_keyword)
    insert(:job_source_tech_keyword, tech_keyword: keyword1, job_source: job_source)
    params = %{
      name: company.name,
      place: "San Francisco, CA, USA",
      url: "http://google.com",
      title: "hoge",
      source: "Sequoia",
      job_title: "job title",
      detail: "detail",
      keywords: [keyword2.name]
    }

    other_job_source = insert(:job_source, job_title: "job title", source: "ycombinator", detail: "other_detail", area: area, company: company)
    job = insert(:job, job_title: job_title, area: area, company: company, title: %{"job_source_id" => other_job_source.id, "priority": other_job_source.priority, "value": other_job_source.title}, url: %{"job_source_id" => other_job_source.id, "priority": other_job_source.priority, "value": other_job_source.url}, detail: %{"job_source_id" => other_job_source.id, "priority": other_job_source.priority, "value": other_job_source.detail})
    keyword3 = insert(:tech_keyword)
    insert(:job_tech_keyword, job: job, tech_keyword: keyword1)
    insert(:job_tech_keyword, job: job, tech_keyword: keyword3)

    JobSourceCreator.perform(params)
    job_source = Repo.one(from j in JobSource, where: j.id == ^job_source.id, preload: [:tech_keywords])
    assert job_source.detail == "detail"
    assert Enum.map(job_source.tech_keywords, &(&1.name)) == [keyword2.name]
    assert Repo.aggregate(JobSource, :count, :id) == 2
    assert Repo.aggregate(Company, :count, :id) == 1
    assert Repo.aggregate(JobTitle, :count, :id) == 1
    assert Repo.aggregate(JobTitleAlias, :count, :id) == 1
    assert Repo.aggregate(JobSourceTechKeyword, :count, :id) == 1

    job = Repo.get(Job, job.id)

    assert job.detail == %{"job_source_id" => job_source.id, "priority" => job_source.priority, "value" => job_source.detail}
    job_tech_keywords = Query.JobTechKeyword.all_by_job_id(Repo, job.id)
    assert Enum.map(job_tech_keywords, &(&1.tech_keyword_id)) == [keyword2.id]
  end

  test "fails to create a job source and rolled back" do
    params = %{
      name: "new company",
      place: "San Francisco, CA, USA",
      url: "http://google.com",
      title: "hoge",
      source: "Sequoia",
      keywords: []
    }


    JobSourceCreator.perform(params)

    assert_raise Ecto.NoResultsError, fn ->
      Repo.get_by!(Company, name: "new company")
    end
  end

end
