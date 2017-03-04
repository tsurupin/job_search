defmodule Customer.Ets do
   use GenServer

   @name :customer_ets

   # TODO: Need to use global name for distribution
   def start_link() do
      GenServer.start_link(__MODULE__, {:ok, []}, name: @name)
   end

   def init({:ok, _args}) do
     ets = :ets.new(@name, [:named_table, :public])
     {:ok, ets}
   end

   def upsert(%{key: key, value: value} = cache) do
     GenServer.cast(@name, {:upsert, cache})
   end

   def fetch(key) do
     GenServer.call(@name, {:fetch, key})
   end

   def handle_call({:fetch, key}, _from, state) do
     value = fetch_value(key)
     {:reply, value, state}
   end

   def handle_cast({:upsert, %{key: key, value: value}}, state) do
      :ets.insert(@name, {key, value})
      {:noreply, state}
   end

   defp fetch_value(key) do
     case :ets.lookup(@name, key) do
        [{key, value}] -> {:ok, value}
        [] -> {:error, "not found"}
      end
   end
end