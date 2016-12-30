defmodule Customer.Repo.Migrations.CreateUserActivity do
  use Ecto.Migration

  def change do
    create table(:user_activities) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :company_id, references(:companies, on_delete: :delete_all)
      add :status, :integer, default: 0, null: false

      timestamps()
    end

    create index(
      :user_activities,
      [:user_id, :company_id],
      unique: true
    )

  end
end
