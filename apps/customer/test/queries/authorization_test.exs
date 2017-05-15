defmodule Customer.Web.Query.AuthorizationTest do
  use Customer.Web.TestWithEcto, async: true

  alias Customer.Web.Query
  alias Customer.Web.{Authorization, User}

  describe "current_auth" do
    test "return latest authorization" do
      user = insert(:user)
      insert(:authorization, user: user)
      auth2 = insert(:authorization, user: user)
      current_auth = Query.Authorization.current_auth(user.id)
      assert current_auth.id == auth2.id
    end

    test "return nil if authorization is not found" do
      assert Query.Authorization.current_auth(1) == nil
    end
  end

  describe "get_by_uid_and_provider" do
    test "return authorization" do
      auth = insert(:authorization)
      result = Query.Authorization.get_by_uid_and_provider(%{uid: auth.uid, provider: auth.provider})
      expected_auth = Repo.one(Ecto.assoc(auth, :user))
      assert result = expected_auth
    end
  end

  describe "user_by" do
    test "return not_found if authorization is not found" do
      assert Query.Authorization.user_by(%Authorization{}, %User{}) == {:error, :not_found}
    end

    test "return not_match if current_user doesn't match to user" do
      auth = insert(:authorization)
      assert Query.Authorization.user_by(auth, nil) == {:error, :not_match}
      different_user = insert(:user)
      assert Query.Authorization.user_by(auth, different_user) == {:error, :not_match}
    end

    test "return user" do
      user = insert(:user)
      auth = insert(:authorization, user: user)
      assert Query.Authorization.user_by(auth, user) == {:ok, user}
    end
  end

end
