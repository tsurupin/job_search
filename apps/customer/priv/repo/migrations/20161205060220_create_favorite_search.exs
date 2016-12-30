defmodule Customer.Repo.Migrations.CreateFavoriteSearch do
  use Ecto.Migration

  def change do
    create table(:favorite_searches) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :conditions, :map
      timestamps()
    end
    create index(:favorite_searches, :user_id)
  end
end
