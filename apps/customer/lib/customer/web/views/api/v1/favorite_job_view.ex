defmodule Customer.Web.Api.V1.FavoriteJobView do
  use Customer.Web, :view

  def render("index.json", %{favorite_jobs: favorite_jobs}) do
    %{favoriteJobs: Enum.map(favorite_jobs, &(parse(&1)))}
  end

  def render("show.json", %{favorite_job_id: favorite_job_id} = param) do
    %{favoriteJobId: favorite_job_id}
  end

  defp parse(%FavoriteJob{interest: interest, job_id: job_id, job: job, status: status, remarks: remarks}) do
    %{
      interest: interest,
      jobId: job_id,
      jobTitle: job.title["value"],
      area: job.area.name,
      status: status,
      company: job.company.name,
      remarks: remarks
    }
  end

end
