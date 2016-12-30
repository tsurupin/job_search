defmodule Customer.Repo.Migrations.CreateUserMemo do
  use Ecto.Migration

  def change do
    create table(:user_memos) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :company_id, references(:companies, on_delete: :delete_all)
      add :description, :text, null: false

      timestamps()
    end

    create index(
      :user_memos,
      [:user_id, :company_id],
      unique: true
    )

  end
end
