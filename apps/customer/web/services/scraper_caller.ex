defmodule Customer.Services.ScraperCaller do

  def perform(urls) do
    scrape(urls)
  end

  defp call([]) do
    IO.puts "done!"
  end

  defp call([head | tail]) do
    Task.start_link(fn -> scrape(head) end)
    call(tail)
  end

  defp scrape("A16z") do
    Customer.Services.Scrapers.A16z.Index.perform()
  end

  defp scrape("Accel") do
    Customer.Services.Scrapers.Accel.Index.perform()
  end

  defp scrape("FirstRound") do
    Customer.Services.Scrapers.FirstRound.perform()
  end

  defp scrape("YCombinator") do
    Customer.Services.Scrapers.YCombinator.Index.perform()
  end

  defp scrape("Sequoia") do
    Customer.Services.Scrapers.Sequoia.Index.perform()
  end

end
