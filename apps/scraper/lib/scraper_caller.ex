defmodule ScraperCaller do

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
    Scrapers.A16z.Index.perform()
  end

  defp scrape("Accel") do
    Scrapers.Accel.Index.perform()
  end

  defp scrape("FirstRound") do
    Scrapers.FirstRound.perform()
  end

  defp scrape("YCombinator") do
    Scrapers.YCombinator.Index.perform()
  end

  defp scrape("Sequoia") do
    Scrapers.Sequoia.Index.perform()
  end

end
