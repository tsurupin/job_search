defmodule Customer.Repo.Migrations.CreateState do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :name, :string, null: false, unique: true
      add :abbreviation, :string, null: false, unique: true

      timestamps()
    end
    create index(:states, :name, unique: true)
    create index(:states, :abbreviation, unique: true)
  end
end
