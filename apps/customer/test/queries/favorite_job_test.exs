defmodule Customer.Web.Query.FavoriteJobTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Query
  alias Customer.Repo

  describe "all_by" do
    test "return empty array if no record found" do
      assert Query.FavoriteJob.all_by(Repo, %{user_id: 1}) == []
    end

    test "return all favorite jobs" do
      user = insert(:user)
      favorite_job1 = insert(:favorite_job, user: user)
      favorite_job2 = insert(:favorite_job, user: user)
      favorite_jobs = Query.FavoriteJob.all_by(Repo, %{user_id: user.id})

      assert Enum.map(favorite_jobs, &(&1.id)) == [favorite_job1.id, favorite_job2.id]
    end
  end

  describe "get_by_user_and_job_id" do
    test "return favorite_job id found" do
      user = insert(:user)
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job)
      params = %{user_id: user.id, job_id: job.id}
      assert {:ok, returned_favorite_job} = Query.FavoriteJob.get_by_user_and_job_id(Repo, params)
      assert favorite_job.id == returned_favorite_job.id
    end

    test "return error if not found" do
      params = %{user_id: 1, job_id: 1}
      assert Query.FavoriteJob.get_by_user_and_job_id(Repo, params) == {:error, :not_found}
    end
  end

  describe "exists?" do
    test "return true if more thant one record found" do
      params = %{user_id: 1, job_id: 1}
      assert Query.FavoriteJob.exists?(Repo, params) == false
    end

    test "return false if no record found" do
     job = insert(:job)
     user = insert(:user)
     insert(:favorite_job, user: user, job: job)
     params = %{user_id: user.id, job_id: job.id}
     assert Query.FavoriteJob.exists?(Repo, params) == true

    end
  end

end
