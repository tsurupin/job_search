defmodule Scraper.Site.A16z.Index do
  alias Scraper.Site.A16z.Show

  @scrapeURL "http://portfoliojobs.a16z.com/careers_home.php?Company=%25&Function=12&Location=%25"

  def perform(url \\ @scrapeURL, page \\ 1)

  @maxPage 15
  def perform(url, page) when page > @maxPage do
    IO.inspect "reaches to limit"
  end

  def perform(url, page) do
    scrape(url, page)
    Task.start(fn -> perform(url, page + 1) end)
  end

  defp scrape(url, page) do
    body(url_with_page(url, page))
      |> Floki.parse
      |> Floki.find(".job_listings")
      |> Floki.find("tr")
      |> Enum.slice(2..-2)
      |> Enum.filter(fn(content) ->
        Enum.any?(Floki.find(content, "a"))
      end)
      |> Enum.each(fn(xml) ->
        parse_each(xml)
      end)
  end

  @defaultTimeout 10000
  defp body(url) do
    %HTTPoison.Response{body: body} = HTTPoison.get!(url, %{}, hackney: [recv_timeout: @defaultTimeout , timeout: @defaultTimeout])
    body
  end

  defp parse_each({_tag, _css, [link, company, place, _date]}) do
    with {_, [{_, link_url}], [job_title]} <- parsed_link(link),
      {_, [{_, company_url}], [company_name]} <- parsed_link(company)
      do
        Task.start(fn -> Show.perform(detail_url(link_url), company_name, job_title, parse_places(place)) end)
      end

  end

  defp parsed_link(link) do
    Floki.find(link, "a")
    |> Enum.at(0)
  end

 @indexURL "http://portfoliojobs.a16z.com/"
  defp detail_url(path) do
    @indexURL <> path
  end

  defp parse_places(html) do
    Floki.find(html, "a")
    |> Enum.map(&(Floki.text(&1)))
  end

  defp url_with_page(url, page) do
    url <> "&p=#{page}"
  end

end
