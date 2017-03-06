defmodule Customer.FavoriteJobControllerTest do
  use Customer.ConnCase, async: true

  alias Customer.FavoriteJob

  setup [:login]

  describe "index" do
    test "get favoite jobs", %{user: user, jwt: jwt} do
      area = insert(:area)
      job_title = insert(:job_title)
      company = insert(:company)
      job = insert(:job, area: area, job_title: job_title, company: company)
      favorite_job = insert(:favorite_job, user: user, job: job)

      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(favorite_job_path(conn, :index))
      assert conn.status == 200
      body = Poison.decode!(conn.resp_body)
      result = %{"favoriteJobs" => [
        %{
          "interest" => favorite_job.interest,
          "status" => favorite_job.status,
          "jobId" => job.id,
          "jobTitle" => job_title.name,
          "area" => area.name,
          "company" => company.name
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
       result = %{"favoriteId" => favorite_job.id}
       assert body = result
    end

    test "get an error message", %{jwt: jwt} do
      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(favorite_job_path(conn, :show, 2))
      assert conn.status == 404

      result = %{"error" => "Not Found"}
      assert body = result
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

    test "faile to create a new favorite job and get 404", %{user: user, jwt: jwt}  do
       job = insert(:job)
       favorite_job = insert(:favorite_job, user: user, job: job)

       conn = build_conn()
         |> put_req_header("authorization", "Bearer #{jwt}")
         |> post(favorite_job_path(conn, :create, %{"id" => job.id}))
       assert conn.status == 404
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

    test "faile to update an existing job and get 400", %{user: user, jwt: jwt} do
      job = insert(:job)
      favorite_job = insert(:favorite_job, user: user, job: job)

      conn = build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put(favorite_job_path(conn, :update, job.id, %{interest: 10}))
      assert conn.status == 404
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

    test "faile to update an existing job and get 404", %{user: user, jwt: jwt} do
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