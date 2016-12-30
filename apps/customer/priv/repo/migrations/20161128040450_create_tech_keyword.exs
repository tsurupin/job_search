defmodule Customer.Repo.Migrations.CreateTechKeyword do
  use Ecto.Migration

  def change do
    create table(:tech_keywords) do
      add :type, :string, null: false
      add :name, :string, nulll: false, unique: true

      timestamps()
    end
    create index(:tech_keywords, :name, unique: true)

  end
end
