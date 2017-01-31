defmodule Customer.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :is_admin, :boolean, default: false

      timestamps()
    end

  end
end
