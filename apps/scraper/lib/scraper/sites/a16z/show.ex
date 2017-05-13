defmodule Scraper.Site.A16z.Show do
  alias Customer.Web.Service.JobSourceCreator
  alias Scraper.Site.Helper.TechKeywordsFinder

  @defaultTimeout 10000
  @minimumSleepSeconds 5
  @randomSleepSeconds 10

  def perform(url, company_name, job_title, places) do
    bulk_upsert(body(url), url, company_name, job_title, places)
  end

  defp bulk_upsert(xml, url, company_name, job_title, []), do: nil
  defp bulk_upsert(xml, url, company_name, job_title, [current_place | remaining]) do
    upsert(xml, url, company_name, job_title, current_place)
    bulk_upsert(xml, url, company_name, job_title, remaining)
  end

  defp body(url) do
    %HTTPoison.Response{body: body} = HTTPoison.get!(url, %{}, hackney: [recv_timeout: @defaultTimeout, timeout: @defaultTimeout])
    body
  end


  defp upsert(xml, url, company_name, job_title, place) do
    params = build_params(xml, url, company_name, job_title, place)

    Task.start_link(fn ->

      case JobSourceCreator.perform(params) do
        {:ok, _} -> IO.inspect "ok"
        {:error, _model, changeset, _} ->
          IO.inspect "fail to upsert"
          :timer.sleep(:timer.seconds(@minimumSleepSeconds + :rand.uniform(@randomSleepSeconds)))
          JobSourceCreator.perform(params)
      end
    end)
  end

  defp build_params(xml, url, company_name, job_title, place) do
    detail = build_detail(xml)
    keywords = TechKeywordsFinder.perform(detail)
    %{
      url: url,
      name: company_name,
      title: job_title,
      job_title: job_title,
      detail: detail,
      place: place,
      source: "A16z",
      keywords: keywords
    }
  end

  defp build_detail(xml) do
    xml
    |> Floki.parse
    |> Floki.find(".wrap-job-description")
    |> Floki.text
    |> String.replace("\n", "<br>")
    |> String.replace("\r", "")
  end

end
