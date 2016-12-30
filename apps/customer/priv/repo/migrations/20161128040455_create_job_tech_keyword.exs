defmodule Customer.Repo.Migrations.CreateJobTechKeyword do
  use Ecto.Migration

  def change do
    create table(:job_tech_keywords) do
      add :tech_keyword_id, references(:tech_keywords, on_delete: :delete_all)
      add :job_id, references(:jobs, on_delete: :delete_all)

      timestamps()
    end
    create unique_index(:job_tech_keywords, [:tech_keyword_id, :job_id], name: :job_tech_keywords_tech_keyword_id_job_id_index)

  end
end
