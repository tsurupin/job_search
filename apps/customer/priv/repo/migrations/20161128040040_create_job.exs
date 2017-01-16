defmodule Customer.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :company_id, references(:companies, on_delete: :delete_all), null: false
      add :area_id, references(:areas, on_delete: :nilify_all), null: false
      add :job_title, :string, null: false
      add :url, :map, null: false
      add :title, :map, null: false
      add :detail, :map

      timestamps()
    end
    create index(:jobs, :company_id)
    create index(:jobs, :area_id)

  end
end
