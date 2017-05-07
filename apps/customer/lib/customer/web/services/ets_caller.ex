defmodule Customer.Web.Service.EtsCaller do
  alias Customer.Ets
  alias Customer.Web.Query
  alias Customer.Repo


  def perform(key, action) do
    fetch_from_ets(key, action)
  end

  defp fetch_from_ets(key, action) do
    case Ets.fetch(key) do
      {:ok, value} ->
        value
      {:error, _reason} ->
        upsert_ets(key, action)
        fetch_from_ets(key, action)
    end
  end

  defp upsert_ets(key, action) do
    value = apply(Module.concat(Query, key), action, [Repo])
    Ets.upsert(%{key: key, value: value})
  end
end