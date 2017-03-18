defmodule Scraper.Cron do
  use GenServer
  require Logger

  # NOTE: every 2 hours
  @period 2 * 60 * 60 * 1000

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    set_schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.info("scraper executes #{DateTime.utc_now()}")
    Scraper.Caller.perform()
    set_schedule_work()
    {:noreply, state}
  end


  defp set_schedule_work() do
    Process.send_after(self(), :work, @period)
  end

end
