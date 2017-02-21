defmodule Customer.Repo.Migrations.CreateJobTitle do
  use Ecto.Migration

  def change do
    create table(:job_titles) do
      add :name, :string, null: false

      timestamps()
    end
    create index(:job_titles, :name, unique: true)
  end
end