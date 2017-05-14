defmodule Customer.Web.Query.JobTitleAlias do
  use Customer.Query, model: JobTitleAlias
  alias Customer.Web.{JobTitle, JobTitleAlias}

  def get_or_find_approximate_job_title(repo, name) when is_nil(name), do: {:error, name}

  def get_or_find_approximate_job_title(repo, raw_name) do
    name = transform_to_string(raw_name)
    case repo.get_by(JobTitle, name: name) do
      %JobTitle{id: id} -> {:ok, id}
      _ ->
        case repo.get_by(JobTitleAlias, name: name) do
          %JobTitleAlias{job_title_id: job_title_id} -> {:ok, job_title_id}
          _ -> find_approximate_job_title(repo.all(JobTitleAlias), name)
        end
    end
  end

  defp find_approximate_job_title([], name) do
    {:error, name}
  end

  defp find_approximate_job_title([%JobTitleAlias{name: name, job_title_id: job_title_id}| remaining], job_title_name) do
    if approximate_word?(transform_to_string(name), job_title_name) do
       {:ok, job_title_id}
    else
       find_approximate_job_title(remaining, job_title_name)
     end
  end

  def transform_to_string(word) do
    word
    |> String.replace(~r/((,|\(|\.|_|:|\/).*|\s+.(-|–).*| – .*|-\s+.*)/,"")
    |> String.trim
    |> String.downcase
  end

  @approximate_word_threshold 0.95
  defp approximate_word?(word1, word2) do
    String.jaro_distance(word1, word2) >= @approximate_word_threshold
  end

end