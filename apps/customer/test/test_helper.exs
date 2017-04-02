{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start
Pact.put(:google_strategy, FakeGoogleStrategy)
Ecto.Adapters.SQL.Sandbox.mode(Customer.Repo, :manual)
