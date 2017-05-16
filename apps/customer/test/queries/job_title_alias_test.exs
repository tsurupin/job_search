defmodule Customer.Web.Query.JobTitleAliasTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Query
  alias Customer.Repo

  describe "get_or_find_approximate_job_title" do
    test "return job_title_id" do
      job_title = insert(:job_title)
      insert(:job_title_alias, job_title: job_title, name: "test title")
      assert {:ok, job_title_id} = Query.JobTitleAlias.get_or_find_approximate_job_title(Repo, "test title")
      assert job_title_id == job_title.id
    end

    test "retuern error" do
      job_title = insert(:job_title)
      insert(:job_title_alias, job_title: job_title, name: "test title")
      assert {:error, "test"} = Query.JobTitleAlias.get_or_find_approximate_job_title(Repo, "test")
    end
  end

end
