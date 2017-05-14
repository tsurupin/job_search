defmodule Scraper.Site.Sequoia.Index do
  use Hound.Helpers
  alias Scraper.Site.Sequoia.Show

  @indexURL "https://www.sequoiacap.com/jobs"
  @rootURL "https://www.sequoiacap.com"

  @retryLimit 3
  def perform(url \\ @indexURL, retry \\ 0) do
    case scrape_links(url) do
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
    navigate_to "#{url}", 1
    :timer.sleep(:timer.seconds(6))
    script = "
      var technicalList = document.getElementById('functionTechnical').getElementsByTagName('li');
      technicalList[1].click();
      technicalList[5].click();
      window.document.getElementsByClassName('-title-check')[2].click();
    "

    execute_script(script)
    :timer.sleep(:timer.seconds(5))
    case page_source() do
      {:error, :timeout} ->
        Hound.end_session
        {:error, :timeout}
      parsed_html ->
        links =
        parsed_html
          |> Floki.parse
          |> Floki.find("#jobs-content")
          |> Floki.find(".js-jobs-filtered-content")
          |> Floki.find("a")
          |> Floki.attribute("href")
        Hound.end_session
        links
    end
  end

  defp parse_detail(path) do

    Task.start(fn -> Show.perform(detail_url(path)) end)
  end

  defp detail_url(path) do
     @rootURL <> path
  end

end
