defmodule Customer.Repo.Migrations.CreateJobSource do
  use Ecto.Migration

  def change do
    create table(:job_sources) do
      add :company_id, references(:companies, on_delete: :delete_all)
      add :area_id, references(:areas, on_delete: :nilify_all), null: false
      add :job_title, :string
      add :title, :string, null: false
      add :url, :string, null: false
      add :detail, :text
      add :source, :string
      add :priority, :integer, default: 0
      timestamps()
    end
    create index(:job_sources, :company_id)
  end
end
