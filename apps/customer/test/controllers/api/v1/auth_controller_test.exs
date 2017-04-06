defmodule Customer.Web.Api.V1.AuthControllerTest do
  use Customer.Web.ConnCase, async: true
  
  test "DELETE /api/v1/auth revokes token and returns status code 200" do
    #conn = guardian_login(user, :token, key: :admin)
  end

  test "GET /auth/:provider/callback receives auth and returns token" do
  end

  test "GET /auth/:provider/callback receives auth and returns error" do
  end

end
