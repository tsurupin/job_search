defmodule Customer.Cron do
  use GenServer
  require Logger

  # NOTE: every day
  @period 24 * 60 * 60 * 1000

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    set_schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.info("esreindex executes #{DateTime.utc_now()}")
    Customer.Builder.EsReindex.perform()
    set_schedule_work()
    {:noreply, state}
  end


  defp set_schedule_work() do
    Process.send_after(self(), :work, @period)
  end

end
