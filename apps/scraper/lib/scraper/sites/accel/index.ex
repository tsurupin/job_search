defmodule Scraper.Site.Accel.Index do
  alias Scraper.Site.Accel.Show

  @scrapeURL "http://careers.accel.com/careers_home.php?Company=%25&Industry=%25&Function=12&Location=%25"

  def perform(url \\ @scrapeURL, page \\ 1)

  def perform(url, page) do
   if page > max_page do
     IO.inspect "reaches to limit"
   else
     scrape(url, page)
     Task.start(fn -> perform(url, page + 1) end)
   end
  end

  @maxPageInProduction 15
  @maxPage 1
  defp max_page do
    if Application.get_env(:scraper, :environment) == :prod do
      @maxPageInProduction
    else
      @maxPage
    end
  end

  defp scrape(url, page) do
    body(url_with_page(url, page))
    |> Floki.parse
    |> Floki.find(".job_listings")
    |> Floki.find("tr")
    |> Enum.slice(2..-2)
    |> Enum.filter(fn(content) -> Enum.any?(Floki.find(content, "a")) end)
    |> Enum.each(fn(xml) -> parse_each(xml) end)
  end

  @defaultTimeout 10000
  defp body(url) do
    %HTTPoison.Response{body: body} = HTTPoison.get!(url, %{}, hackney: [recv_timeout: @defaultTimeout , timeout: @defaultTimeout])
    body
  end

  defp parse_each({_tag, _css, [link, company, place]}) do
    with {_, [{_, link_url}], [job_title]} <- parsed_link(link),
      {_, [{_, company_url}], [company_name]} <- parsed_link(company),
      do: Task.start_link(fn -> Show.perform(detail_url(link_url), company_name, job_title, Floki.text(place)) end)
  end

  defp parsed_link(link) do
    Floki.find(link, "a")
    |> Enum.at(0)
  end

  @indexURL "http://careers.accel.com/"
  defp detail_url(path) do
    @indexURL <> path
  end

  defp url_with_page(url, page) do
    url <> "&p=#{page}"
  end

end
