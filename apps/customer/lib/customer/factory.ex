defmodule Customer.Factory do
  use ExMachina.Ecto, repo: Customer.Repo

  def company_factory do
    %Customer.Web.Company{
      name: sequence(:name, &"hoge#{&1}"),
      url: "http://google.com"
    }
  end

  def user_factory do
    %Customer.Web.User{
      name: "name",
      email: sequence(:email, &"test#{&1}@gmail.com")
    }
  end

  def authorization_factory do
    %Customer.Web.Authorization{
      provider: "google",
      token: "token",
      uid: sequence(:uid, &"uid#{&1}"),
      user: build(:user)
    }
  end

  def job_factory do
    %Customer.Web.Job{
      company: build(:company),
      area: build(:area),
      job_title: build(:job_title),
      title: %{"value" => "title"},
      url: %{"value": "http://google.com"},
      detail: %{"value" => "detail"}
    }
  end

  def state_factory do
    %Customer.Web.State{
      name: sequence(:name, &"name#{&1}"),
      abbreviation: sequence(:abbreviation, &"name#{&1}")
    }
  end

  def area_factory do
    %Customer.Web.Area{
      state: build(:state),
      name: sequence(:name, &"hoge#{&1}")
    }
  end

  def job_title_factory do
    %Customer.Web.JobTitle{
      name: sequence(:name, &"hoge#{&1}")
    }
  end

  def job_title_alias_factory do
    %Customer.Web.JobTitleAlias{
       job_title: build(:job_title),
       name: sequence(:name, &"hoge#{&1}")
    }
  end

  def job_source_factory do
    %Customer.Web.JobSource{
      company: build(:company),
      area: build(:area),
      title: "hoge",
      url: "http://google.com"
    }
  end

  def tech_keyword_factory do
     %Customer.Web.TechKeyword{
       name: sequence(:name, &"keyword#{&1}"),
       type: "hoge"
     }
  end

  def job_tech_keyword_factory do
     %Customer.Web.JobTechKeyword{
       job: build(:job),
       tech_keyword: build(:tech_keyword)
     }
  end

  def job_source_tech_keyword_factory do
     %Customer.Web.JobSourceTechKeyword{
       job_source: build(:job_source),
       tech_keyword: build(:tech_keyword)
     }
  end

  def favorite_job_factory do
    %Customer.Web.FavoriteJob{
      job: build(:job),
      user: build(:user)
    }
  end

  def job_application_factory do
    %Customer.Web.JobApplication{
      job: build(:job),
      user: build(:user)
    }
  end
end
