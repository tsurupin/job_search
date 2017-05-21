defmodule Customer.Es.Filter.Job do
  import Tirexs.Query
  import Tirexs.Search
  require Tirexs.Query.Filter

  def perform(%{job_title: job_title, area: area, techs: techs, detais: detail}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "job_title", es_term(job_title)
          term "area", es_term(area)
          terms "techs",    es_terms(techs(techs))
          match "detail", es_term(detail)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{job_title: job_title, area: area, techs: techs}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "job_title", es_term(job_title)
          term "area", es_term(area)
          terms "techs",    es_terms(techs(techs))
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{area: area, techs: techs, detail: detail}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "area", es_term(area)
          terms "techs",    es_terms(techs(techs))
          match "detail", es_term(detail)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{job_title: job_title, techs: techs, detail: detail}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "job_title", es_term(job_title)
          terms "techs",    es_terms(techs(techs))
          match "detail", es_term(detail)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{job_title: job_title, area: area, detail: detail}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "job_title", es_term(job_title)
          term "area", es_term(area)
          match "detail", es_term(detail)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{job_title: job_title, area: area}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "job_title", es_term(job_title)
          term "area", es_term(area)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{job_title: job_title, techs: techs}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "job_title", es_term(job_title)
          terms "techs",    es_terms(techs(techs))
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{job_title: job_title, detail: detail}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "job_title", es_term(job_title)
          match "detail", es_term(detail)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{techs: techs, detail: detail}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "techs", es_terms(techs(techs))
          match "detail", es_term(detail)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{area: area, techs: techs}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "area", es_term(area)
          terms "techs", es_terms(techs(techs))
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{area: area, detail: detail}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "area", es_term(area)
          match "detail", es_term(detail)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{job_title: job_title}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "job_title", es_term(job_title)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{area: area}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          term "area", es_term(area)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{techs: techs}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "techs", es_terms(techs(techs))
        end
      end
    end
    |> Keyword.get(:filter)
  end

  def perform(%{detail: detail}) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          match "detail", es_term(detail)
        end
      end
    end
    |> Keyword.get(:filter)
  end

  defp techs(values) do
    values
    |> String.split(",")
    |> Enum.map(&(String.trim(&1)))
  end

  defp es_term(value), do: downcase(value)

  defp es_terms(values) when is_list(values), do: downcase(values)

  defp downcase(values) when is_list(values) do
    Enum.map(values, &(downcase(&1)))
  end

  defp downcase(value), do: String.downcase(value)

end
