defmodule Customer.Web.Query.JobTitleAlias do
  use Customer.Query, model: JobTitleAlias
  alias Customer.Web.JobTitleAlias

  def get_or_find_approximate_job_title(repo, name) do
    case repo.get_by(JobTitleAlias, name: name) do
      %JobTitleAlias{job_title_id: job_title_id} -> {:ok, job_title_id}
      _ -> find_approximate_job_title(repo.all(JobTitleAlias), transform_to_string(name))
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

  defp transform_to_string(word) do
    word
    |> String.replace(~r/[\s,\.-_]/, "", global: true)
    |> String.downcase
  end

  @approximate_word_threshold 0.9
  defp approximate_word?(word1, word2) do
    String.jaro_distance(word1, word2) >= @approximate_word_threshold
  end

end