defmodule Scraper.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, ok)
  end

  def init(:ok) do
    children = [
      worker(Scraper.Registory [Scraper.Registory])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
