defmodule Customer.Web.Query.JobTitleTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Query
  alias Customer.Repo

  test "names" do
    job_title = insert(:job_title)
    assert Query.JobTitle.names(Repo) == [job_title.name]
  end


end
