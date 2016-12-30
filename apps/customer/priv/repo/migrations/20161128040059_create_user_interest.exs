defmodule Customer.Repo.Migrations.CreateUserInterest do
  use Ecto.Migration

  def change do
    create table(:user_interests) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :company_id, references(:companies, on_delete: :delete_all)
      add :degree, :integer, null: false

      timestamps()
    end

    create index(
      :user_interests,
      [:user_id, :company_id],
      unique: true
    )

  end
end
