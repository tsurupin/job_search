defmodule Customer.Auth.AuthorizerTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.{Authorization, User}
  alias Customer.Web.Command
  alias Customer.Auth.Authorizer

  describe "get_or_insert" do

   test "creates authorization if auth is not found" do
    user = insert(:user)

    auth = %{
      uid: "random",
      provider: :google,
      info: %{
        name: "name",
        first_name: "first",
        last_name: "last",
        nickname: "nickname",
        email: "test@sample.com"
      },
      credentials: %{token: "token", refresh_token: "refresh_token", expires_at: 1111 }
    }
    assert Repo.get_by(Authorization, user_id: user.id) == nil
    assert {:ok, user} == Authorizer.get_or_insert(auth, user)
    refute Repo.get_by(Authorization, user_id: user.id) == nil
   end

    test "creates user and authorization if auth is not found and current_user is nil" do
      auth = %{
         uid: "random",
         provider: :google,
         info: %{
           name: "name",
           first_name: "first",
           last_name: "last",
           nickname: "nickname",
           email: "test@sample.com"
         },
         credentials: %{token: "token", refresh_token: "refresh_token", expires_at: 1111 }
       }
      assert Repo.one(User) == nil
      assert {:ok, user} = Authorizer.get_or_insert(auth)
      assert user.email == auth.info.email
      refute Repo.get_by(Authorization, user_id: user.id) == nil
    end

    test "refresh authorization" do
      user = insert(:user)
      authorization = insert(:authorization, user: user, provider: "google")
      auth = %{uid: authorization.uid, provider: :google}
      assert {:ok, user} = Authorizer.get_or_insert(auth, user)
      refreshed_authorization = Repo.get(Authorization, authorization.id)
      refute refreshed_authorization.refresh_token == authorization.refresh_token
      refute refreshed_authorization.expired_at == authorization.expired_at
    end

    test "returns current_auth" do
       user = insert(:user)
       authorization = insert(:authorization, user: user, provider: "google", expired_at: Guardian.Utils.timestamp + 1_000)
       auth = %{uid: authorization.uid, provider: :google}
       assert {:ok, user} == Authorizer.get_or_insert(auth, user)
    end
  end
end
