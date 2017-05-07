defmodule Customer.Web.Command.JobTitle do
  use Customer.Command, model: Customer.Web.JobTitle
  alias Customer.Web.{JobTitle, JobTitleAlias}

  def insert_job_title_and_alias(name), do: insert_job_title_and_alias(Multi.new, name)

  def insert_job_title_and_alias(multi, name) do
    Multi.insert(multi, :job_title, JobTitle.build(%{name: name}))
    |> Multi.merge(fn %{job_title: job_title} ->
      Multi.insert(Multi.new, :job_title_alias, JobTitleAlias.build(%{name: name, job_title_id: job_title.id}))
    end)
  end

end