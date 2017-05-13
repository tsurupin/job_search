defmodule Scraper.Site.Accel.Show do
  alias Customer.Web.Service.JobSourceCreator
  alias Scraper.Site.Helper.TechKeywordsFinder

  @defaultTimeout 10000

  def perform(url, company_name, job_title, place) do
    body(url)
    |> params(url, company_name, job_title, place)
    |> upsert
  end

  defp body(url) do
    %HTTPoison.Response{body: body} = HTTPoison.get!(url, %{}, hackney: [recv_timeout: @defaultTimeout, timeout: @defaultTimeout])
    body
  end

  defp params(xml, url, company_name, job_title, place) do
    detail = build_detail(xml)
    keywords = TechKeywordsFinder.perform(detail)
    %{
      url: url,
      name: company_name,
      title: job_title,
      job_title: job_title,
      detail: detail,
      place: place,
      source: "Accel",
      keywords: keywords
    }
  end

  defp build_detail(xml) do
    xml
    |> Floki.parse
    |> Floki.find(".detailtext")
    |> Floki.text
    |> String.replace("\n", "<br>")
    |> String.replace("\r", "")
  end

  defp upsert(params), do: JobSourceCreator.perform(params)

end
