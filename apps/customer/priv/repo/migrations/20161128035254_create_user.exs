defmodule Customer.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end
    create index(:users, [:email, :password_hash], unique: true)

  end
end
