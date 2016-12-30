defmodule Customer.Repo.Migrations.CreateCompany do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string, null: false
      add :url, :string, null: false

      timestamps()
    end
    create index(:companies, :name, unique: true)


  end
end
