defmodule Customer.Factory do
  use ExMachina.Ecto, repo: Customer.Repo

  def company_factory do
    %Customer.Company{
      name: sequence(:name, &"hoge#{&1}"),
      url: "http://google.com"
    }
  end

  def job_factory do
    %Customer.Job{
      company: build(:company),
      area: build(:area),
      job_title: "job_title",
      title: %{"value" => "title"},
      url: %{"value": "http://google.com"}
    }
  end

  def state_factory do
    %Customer.State{
      name: sequence(:name, &"name#{&1}"),
      abbreviation: sequence(:abbreviation, &"name#{&1}")
    }
  end

  def area_factory do
    %Customer.Area{
      state: build(:state),
      name: sequence(:name, &"hoge#{&1}")
    }
  end

  def job_source_factory do
    %Customer.JobSource{
      company: build(:company),
      area: build(:area),
      title: "hoge",
      url: "http://google.com"
    }
  end

  def tech_keyword_factory do
     %Customer.TechKeyword{
       name: sequence(:name, &"keyword#{&1}"),
       type: "hoge"
     }
  end

  def job_tech_keyword_factory do
     %Customer.JobTechKeyword{
       job: build(:job),
       tech_keyword: build(:tech_keyword)
     }
  end

  def job_source_tech_keyword_factory do
     %Customer.JobSourceTechKeyword{
       job_source: build(:job_source),
       tech_keyword: build(:tech_keyword)
     }
  end
end
