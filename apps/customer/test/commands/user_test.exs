defmodule Customer.Web.Command.UserTest do
  use Customer.Web.TestWithEcto, async: true
  alias Customer.Web.User
  alias Customer.Web.Command
  alias Customer.Repo
  alias Ecto.Multi

  describe "get_or_insert_by" do
    test "return insert multi if user is not found" do

      auth = %{
        info: %{
          name: "",
          first_name: "first",
          last_name: "last",
          nickname: "nickname",
          email: "test@sample.com"
        }
      }
      changeset = User.registration_changeset(%User{}, auth.info)
      multi = Command.User.get_or_insert_by(Multi.new, auth)
      assert multi.names == MapSet.new([:user])
      assert multi.operations == [{:user, {:changeset, %{ changeset| action: :insert}, []}}]
    end

    test "returns multi with user if user is found" do
      user = insert(:user, email: "sample@sample.com")
      auth = %{info: %{email: "sample@sample.com"}}
      multi = Command.User.get_or_insert_by(Multi.new, auth)
      assert {:ok, data} = Repo.transaction(multi)
      assert data.user == user
    end
  end


end
