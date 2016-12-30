defmodule Customer.Repo.Migrations.CreateJobSourceTechKeyword do
  use Ecto.Migration

  def change do
    create table(:job_source_tech_keywords) do
      add :tech_keyword_id, references(:tech_keywords, on_delete: :delete_all)
      add :job_source_id, references(:job_sources, on_delete: :delete_all)

      timestamps()
    end
    create unique_index(:job_source_tech_keywords, [:tech_keyword_id, :job_source_id], name: :job_source_tech_keywords_tech_keyword_id_job_source_id_index)

  end
end
