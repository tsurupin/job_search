defmodule Customer.Web.Query.Job do
  use Customer.Query, model: Customer.Web.Job
  alias Customer.Web.Job

  def get_with_associations(repo, id) do
    with_association(id)
    |> repo.one
  end

  def all_by_company_id(repo,company_id) do
    by_company_id(company_id)
    |> repo.all
  end

  defp with_association(id) do
    from j in Job, where: j.id == ^id, preload: [:area, :company, :tech_keywords, :job_title]
  end

  defp by_company_id(company_id) do
    from j in Job, where: j.company_id == ^company_id, preload: [:area, :job_title]
  end

end
