defmodule Customer.Web.FavoriteJobControllerTest do
  use Customer.Web.ConnCase, async: true

  alias Customer.Web.{FavoriteJob, JobApplication}

  setup [:login]

  describe "index" do
    test "get favoite jobs", %{user: user, jwt: jwt} do
      area = insert(:area)
      company = insert(:company)
      job = insert(:job, area: area, company: company)
      favorite_job = insert(:favorite_job, user: user, job: job)

      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(favorite_job_path(conn, :index))
      assert conn.status == 200
      body = Poison.decode!(conn.resp_body)
      result = %{"favoriteJobs" => [
        %{
          "interest" => favorite_job.interest,
          "jobId" => job.id,
          "jobTitle" => job.title["value"],
          "status" => favorite_job.status,
          "area" => area.name,
          "company" => company.name,
          "remarks" => favorite_job.remarks
        }
       ]}
      assert body == result
    end

    test "get 401 without login" do
      conn = build_conn() |> get(favorite_job_path(conn, :index))
      assert conn.status == 401
    end
  end

  describe "show" do
    test "get a favorite job", %{user: user, jwt: jwt} do
       job = insert(:job)
       favorite_job = insert(:favorite_job, user: user, job: job)

       conn = build_conn()
         |> put_req_header("authorization", "Bearer #{jwt}")
         |> get(favorite_job_path(conn, :show, job.id))
       assert conn.status == 200
       body = Poison.decode!(conn.resp_body)
       result = %{"favoriteJobId" => favorite_job.id}
       assert body == result
    end

    test "get an error message", %{jwt: jwt} do
      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(favorite_job_path(conn, :show, 2))
      assert conn.status == 404
      body = Poison.decode!(conn.resp_body)

      assert body == %{"errorMessage" =>"Not Found"}
    end
  end

  describe "create" do
    test "create a new favorite job and get 201", %{user: user, jwt: jwt} do
       job = insert(:job)

       conn = build_conn()
         |> put_req_header("authorization", "Bearer #{jwt}")
         |> post(favorite_job_path(conn, :create, %{"id" => job.id}))
       assert conn.status == 201
    end

    test "create a new favorite job of which status is same as existing job application's status and get 201", %{user: user, jwt: jwt} do
       job = insert(:job)

       job_application = insert(:job_application, user: user, job: job, status: 3)
       conn = build_conn()
         |> put_req_header("authorization", "Bearer #{jwt}")
         |> post(favorite_job_path(conn, :create, %{"id" => job.id}))
       assert conn.status == 201
       favorite_job = Repo.one(FavoriteJob)
       assert favorite_job.status == job_application.status
    end

    test "fail to create a new favorite job and get 404", %{user: user, jwt: jwt}  do
       job = insert(:job)
       favorite_job = insert(:favorite_job, user: user, job: job)

       conn = build_conn()
         |> put_req_header("authorization", "Bearer #{jwt}")
         |> post(favorite_job_path(conn, :create, %{"id" => job.id}))
       body = Poison.decode!(conn.resp_body)
       assert conn.status == 422
       assert body == %{"errorMessage" => "job_id: has already been taken"}
    end
  end

  describe "update" do
    test "update an existing favorite job and get 200", %{user: user, jwt: jwt} do
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job)

      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(favorite_job_path(conn, :update, job.id, %{interest: 4}))
      assert conn.status == 200
      Repo.one(FavoriteJob).interest == 4
    end


    test "update existing job application and get 200", %{user: user, jwt: jwt}  do
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job, status: 0)
      job_application = insert(:job_application, user: user, job: job, status: 0)
      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(favorite_job_path(conn, :update, job.id, %{status: 1, comment: "comment"}))
      assert conn.status == 200
      updated_job_application = Repo.one(JobApplication)
      updated_favorite_job = Repo.one(FavoriteJob)
      assert updated_job_application.status == 1
      assert updated_job_application.comment == "comment"
      assert updated_favorite_job.status == 1
    end


    test "update favorite job and create job application and get 200", %{user: user, jwt: jwt}  do
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job)

      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(favorite_job_path(conn, :update, job.id, %{status: 1, comment: "comment"}))
      assert conn.status == 200

      Repo.one(FavoriteJob).status == 1
      Repo.one(JobApplication).status == 1
    end

    test "update comment of existing job application and get 200", %{user: user, jwt: jwt}  do
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job, status: 0)
      job_application = insert(:job_application, user: user, job: job, status: 0)
      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(favorite_job_path(conn, :update, job.id, %{comment: "comment"}))
      assert conn.status == 200

      Repo.one(JobApplication).comment == "comment"
    end

    test "fail to update an comment because job application doesn't exist and get 400", %{user: user, jwt: jwt}  do
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job, status: 0)

      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(favorite_job_path(conn, :update, job.id, %{comment: "test"}))
      assert conn.status == 404
    end

    test "fail to update an existing job and get 422", %{user: user, jwt: jwt} do
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job)

      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(favorite_job_path(conn, :update, job.id, %{interest: 10}))
      assert conn.status == 422
      Repo.one(FavoriteJob).interest == 3
    end
  end

   describe "delete" do
    test "delete an existing favorite job and get 200", %{user: user, jwt: jwt} do
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job)

      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> delete(favorite_job_path(conn, :delete, job.id))
      assert conn.status == 200
      assert Repo.aggregate(FavoriteJob, :count, :id) == 0
    end

    test "fail to delete an existing job and get 404", %{user: user, jwt: jwt} do
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job)

      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> delete(favorite_job_path(conn, :delete, job.id+1))
      assert conn.status == 404
      assert Repo.aggregate(FavoriteJob, :count, :id) == 1
    end
  end


  def login(_context) do
    user = insert(:user)
    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)
    {:ok, %{user: user, jwt: jwt, claims: full_claims}}
  end

end
