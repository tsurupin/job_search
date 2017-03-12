defmodule Customer.Web.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Customer.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Customer.Factory

      import Customer.Web.Router.Helpers

      # The default endpoint for testing
      @endpoint Customer.Web.Endpoint

      # def guardian_login(%Plug.Conn{} = conn, user, token, opts) do
      #   user = create(:user)
      #   conn
      #   current_user = Guardian.Plug.api_sign_in(conn, user)
      #     |> send_resp(200, "Flush the session yo")
      #     |> recycle()
      # end
      # http://stackoverflow.com/questions/38091540/testing-token-authentication
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Customer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Customer.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
