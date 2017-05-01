defmodule Customer.Web.Command.JobTitleTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Command
  alias Customer.Repo

  test "insert_job_title_and_alias" do
    multi = Command.JobTitle.insert_job_title_and_alias("title")
    assert {:ok, data} = Repo.transaction(multi)
    assert data.job_title
    assert data.job_title_alias.job_title_id == data.job_title.id
  end

end
