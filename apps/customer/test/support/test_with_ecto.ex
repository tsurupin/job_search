defmodule Customer.Web.TestWithEcto do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Customer.Factory
      alias Customer.Repo
      import Ecto.Query, only: [from: 2]
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Customer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Customer.Repo, {:shared, self()})
    end

    :ok
  end
end
