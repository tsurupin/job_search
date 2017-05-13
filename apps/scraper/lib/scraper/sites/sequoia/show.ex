defmodule Scraper.Site.Sequoia.Show do
  alias Scraper.Site.Helper.TechKeywordsFinder
  alias Customer.Web.Service.JobSourceCreator

  @defaultTimeout 10000

  def perform(url) do
    body(url)
    |> Floki.parse
    |> params(url)
    |> upsert
  end

  defp body(url) do
    %HTTPoison.Response{body: body} = HTTPoison.get!(url, %{}, hackney: [recv_timeout: @defaultTimeout, timeout: @defaultTimeout])
    body
  end

  defp upsert(params) do
    JobSourceCreator.perform(params)
  end

  defp params(xml, url) do
    detail = build_detail(xml)
    job_title = job_title(xml)
    keywords = TechKeywordsFinder.perform(detail)
     %{
       url: url,
       name: company_name(xml),
       title: job_title,
       job_title: job_title,
       intro: intro(xml),
       place: place(xml),
       detail: detail,
       source: "Sequoia",
       keywords: keywords
     }
  end

  def company_name(xml) do
    xml
    |> Floki.find("._large-title")
    |> Floki.text
  end

  defp job_title(xml) do
    xml
    |> Floki.find("._job-desc-title")
    |> Floki.text
  end

  defp intro(xml) do
    xml
    |> Floki.find("._intro-copy")
    |> Floki.text
  end

  def place(xml) do
    xml
    |> Floki.find("._content")
    |> Floki.find(".-block")
    |> Floki.find(".-grey")
    |> Floki.text
    |> String.trim
  end

  defp build_detail(xml) do
    xml
      |> Floki.find("._job-description")
      |> Floki.find(".-grey")
      |> Floki.text
      |> String.replace("\n", "<br>")
      |> String.replace("\r", "")
  end

end
