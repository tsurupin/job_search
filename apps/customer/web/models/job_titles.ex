defmodule Customer.JobTitles do
  use Customer.Web, :crud

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def names do
    JobTitle.names |> Repo.all
  end

  def create_job_title_and_alias(name), do: create_job_title_and_alias(Multinew, name)

  def create_job_title_and_alias(multi, name) do
    Multi.insert(multi, :job_title, JobTitle.build(%{name: name}))
    |> Multi.merge(fn %{job_title: job_title} ->
      Multi.insert(Multi.new, :job_title_alias, JobTitleAlias.build(%{name: name, job_title_id: job_title.id}))
    end)
  end


end
