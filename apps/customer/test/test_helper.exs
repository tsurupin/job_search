{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:wallaby)
ExUnit.start
Pact.put(:google_strategy, FakeGoogleStrategy)
Ecto.Adapters.SQL.Sandbox.mode(Customer.Repo, :manual)
