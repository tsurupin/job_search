defmodule Customer.Repo.Migrations.CreateArea do
  use Ecto.Migration

  def change do
    create table(:areas) do
      add :name, :string, null: false, unique: true
      add :state_id, references(:areas, on_delete: :delete_all)

      timestamps()
    end
    create index(:areas, :name, unique: true)

  end
end
