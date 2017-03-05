defmodule Customer.Repo.Migrations.CreateFavoriteJob do
  use Ecto.Migration

  def change do
    create table(:favorite_jobs) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :job_id, references(:jobs, on_delete: :delete_all)
      add :interest, :integer, default: 3, null: false
      add :status, :integer, default: 0, null: false
      add :remarks, :text
      timestamps()
    end

    create unique_index(:favorite_jobs, [:user_id, :job_id], name: :favorite_job_user_id_and_job_id_unique_index)
  end
end
