defmodule Scraper.Sites.Sequoia.Index do
  use Hound.Helpers
  alias Scraper.Sites.Sequoia.Show

  @indexURL "https://www.sequoiacap.com/jobs/?filters=19+13+15+12+sanfrancisco+peninsula+southbay+eastbay"
  @rootURL "https://www.sequoiacap.com"

  def perform(url \\ @indexURL) do
    scrape_links(url)
    |> Enum.each(fn(link) -> parse_detail(link) end)
  end

  defp scrape_links(url) do
    Hound.start_session
    navigate_to "#{url}"
    links =
      page_source()
      |> Floki.parse
      |> Floki.find("#jobs-content")
      |> Floki.find("a")
      |> Floki.attribute("href")
    Hound.end_session
    links
  end

  defp parse_detail(path) do
    Task.start_link(fn -> Show.perform(detail_url(path)) end)
  end

  defp detail_url(path) do
     @rootURL <> path
  end

end
