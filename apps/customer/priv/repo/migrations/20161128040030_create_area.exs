defmodule Customer.Repo.Migrations.CreateArea do
  use Ecto.Migration

  def change do
    create table(:areas) do
      add :name, :string, null: false
      add :state_id, references(:states, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:areas, [:name, :state_id], name: :area_name_state_id_unique_index)
  end
end
