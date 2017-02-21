defmodule Customer.Repo.Migrations.CreateJobTitleAlias do
  use Ecto.Migration

  def change do
    create table(:job_title_aliases) do
      add :name, :string, null: false
      add :job_title_id, references(:job_titles, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:job_title_aliases, :job_title_id)
    create index(:job_title_aliases, :name , unique: true)

  end
end

