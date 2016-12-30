defmodule Customer.Services.JobSourceCreatorTest do
  use Customer.TestWithEcto, async: true
  alias Customer.Services.JobSourceCreator
  alias Customer.{JobSource, Company, JobSourceTechKeyword}

  test "updates job source" do
    company = insert(:company)
    state = insert(:state, abbreviation: "CA")
    area = insert(:area, state: state, name: "San Francisco")
    job_source = insert(:job_source, url: "http://google.com", title: "hoge", source: "Sequoia", area: area, company: company)
    keyword1 = insert(:tech_keyword)
    keyword2 = insert(:tech_keyword)
    insert(:job_source_tech_keyword, tech_keyword: keyword1, job_source: job_source)
    params = %{
      name: company.name,
      place: "San Francisco, CA, USA",
      url: "http://google.com",
      title: "hoge",
      source: "Sequoia",
      job_title: "new job title",
      detail: "detail",
      keywords: [keyword2.name]
    }

    JobSourceCreator.perform(params)
    job_source = Repo.one(from j in JobSource, where: j.title == "hoge", preload: [:tech_keywords])
    assert job_source.detail == "detail"
    assert Enum.map(job_source.tech_keywords, &(&1.name)) == [keyword2.name]
    assert Repo.aggregate(JobSource, :count, :id) == 1
    assert Repo.aggregate(Company, :count, :id) == 1
    assert Repo.aggregate(JobSourceTechKeyword, :count, :id) == 1
  end

  test "creates a job source" do
    state = insert(:state, abbreviation: "CA")
    insert(:area, state: state, name: "San Francisco")
    keyword1 = insert(:tech_keyword)
    keyword2 = insert(:tech_keyword)
    params = %{
      name: "new company",
      place: "San Francisco, CA, USA",
      url: "http://google.com",
      title: "hoge",
      source: "Sequoia",
      keywords: [keyword1.name, keyword2.name]
    }
    JobSourceCreator.perform(params)
    job_source = Repo.one(from j in JobSource, preload: [:tech_keywords, :company, :area])
    assert job_source.title == "hoge"
    assert Enum.map(job_source.tech_keywords, &(&1.name)) == [keyword1.name, keyword2.name]
    assert job_source.company.name == "new company"
    assert job_source.area.name == "San Francisco"
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
    assert_raise Ecto.NoResultsError, fn ->
      JobSourceCreator.perform(params)
    end

    assert_raise Ecto.NoResultsError, fn ->
      Repo.get_by!(Company, name: "new company")
    end
  end

end
