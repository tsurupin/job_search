defmodule Scraper.Caller do
  require Logger

  alias Scraper.Site.{A16z, Accel, FirstRound,YCombinator,Sequoia}
  @sites ~w(A16z Accel)

  def perform do
    Logger.info("start calling!")
    call(@sites)
  end

  defp call([]) do
    Logger.info("finish calling!")
  end

  defp call([head | tail]) do
    Task.start_link(fn -> scrape(head) end)
    call(tail)
  end

  defp scrape("A16z") do
    A16z.Index.perform()
  end

  defp scrape("Accel") do
    Accel.Index.perform()
  end

  # TODO: Need to make selenium work in background
  defp scrape("Sequoia") do
    Sequoia.Index.perform()
  end


end
