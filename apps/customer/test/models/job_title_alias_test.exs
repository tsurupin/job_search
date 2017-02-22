defmodule Customer.JobTitleAliasTest do
  use Customer.TestWithEcto, async: true

    alias Customer.JobTitleAlias

    describe "get_or_find_approximate_job_title" do
      test "return existing job_title_alias's job_title_id" do
        job_title_alias = insert(:job_title_alias)
        assert JobTitleAlias.get_or_find_approximate_job_title(job_title_alias.name) == {:ok, job_title_alias.job_title_id}
      end

      test "return job_title after traversing JobTitleAlias records" do
        job_title_alias1 = insert(:job_title_alias)
        job_title_alias2 = insert(:job_title_alias)
        assert JobTitleAlias.get_or_find_approximate_job_title("test") == {:error, "test"}
      end

      test "return approximate job_title_id" do
        job_title_alias1 = insert(:job_title_alias, name: "title1")
        job_title_alias2 = insert(:job_title_alias, name: "_test-title, 2")
        assert JobTitleAlias.get_or_find_approximate_job_title("testtitle2") == {:ok, job_title_alias2.job_title_id}
      end
    end
end