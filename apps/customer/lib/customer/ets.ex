defmodule Customer.Ets do
   use GenServer

   @ets_name :customer_ets
   @server_name {:global, @ets_name}

   def start_link() do
      GenServer.start_link(__MODULE__, {:ok, []}, name: @server_name)
   end

   def init({:ok, _args}) do
     ets = :ets.new(@ets_name, [:named_table, :public])
     {:ok, ets}
   end

   def reset() do
     GenServer.call(@server_name, {:reset})
   end

   def upsert(%{key: key, value: value} = cache) do
     GenServer.call(@server_name, {:upsert, cache})
   end

   def async_upsert(%{key: key, value: value} = cache) do
     GenServer.cast(@server_name, {:upsert, cache})
   end

   def fetch(key) do
     GenServer.call(@server_name, {:fetch, key})
   end

   def handle_call({:fetch, key}, _from, state) do
     value = fetch_value(key)
     {:reply, value, state}
   end

   def handle_call({:upsert, %{key: key, value: value}}, _from, state) do
     :ets.insert(@ets_name, {key, value})
     value = fetch_value(key)
     {:reply, value, state}
   end

   def handle_call({:reset}, _from, _state) do
     :ets.delete(@ets_name)
     ets = :ets.new(@ets_name, [:named_table, :public])
     {:reply, :ok, ets}
   end

   def handle_cast({:upsert, %{key: key, value: value}}, state) do
      :ets.insert(@ets_name, {key, value})
      {:noreply, state}
   end

   defp fetch_value(key) do
     case :ets.lookup(@ets_name, key) do
        [{key, value}] -> {:ok, value}
        [] -> {:error, "not found"}
      end
   end
end
