defmodule Customer.Web.Command.AuthorizationTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.Authorization
  alias Customer.Web.Command
  alias Ecto.Multi

  describe "insert_by" do
    test "returns insert multi" do
      user = insert(:user)
      auth = %{
        provider: :google,
        uid: "uuid",
        credentials: %{token: "token", refresh_token: "refresh_token", expires_at: 1111 }
      }
      multi = Command.Authorization.insert_by(Multi.new, user, auth)
      changeset = Authorization.build_from_user_with_auth(user, auth)
      assert multi.operations == [{:authorization, {:changeset, %{changeset | action: :insert}, []}}]
    end
  end

  describe "refresh_authorization" do
    test "return error if claims are not found" do

    end

    test "return update multi with guardian" do
      user = insert(:user)
      authorization = insert(:authorization, user: user)
      multi = Command.Authorization.refresh_authorization(user, authorization)

      assert {:ok, data} = Repo.transaction(multi)
      refute data.authorization.refresh_token == authorization.refresh_token
      refute data.authorization.expired_at == authorization.expired_at

    end
  end


end
