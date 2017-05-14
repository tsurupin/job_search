defmodule Scraper.Site.Sequoia.Index do
  use Hound.Helpers
  alias Scraper.Site.Sequoia.Show

  @indexURL "https://www.sequoiacap.com/jobs/?filters=47+19+12+sanfrancisco+peninsula+southbay+eastbay"
  @rootURL "https://www.sequoiacap.com"

  @retryLimit 3
  def perform(url \\ @indexURL, retry \\ 0) do
    case (scrape_links(url)) do
      {:error, :timeout} ->
        if retry > @retryLimit do
          IO.inspect "failed to scrape"
        else
          perform(url, retry + 1)
        end
      links -> Enum.each(links, &(parse_detail(&1)))

    end
  end

  defp scrape_links(url) do
    Hound.start_session
    navigate_to "#{url}", 2
    :timer.sleep(:timer.seconds(2))

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
    Task.start(fn -> Show.perform(detail_url(path)) end)
  end

  defp detail_url(path) do
     @rootURL <> path
  end

end
