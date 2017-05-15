defmodule Customer.Repo.Migrations.CreateFavoriteJob do
  use Ecto.Migration

  def change do
    create table(:favorite_jobs) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :job_id, references(:jobs, on_delete: :delete_all)
      add :interest, :integer, default: 1, null: false, check: "interest >= 1 AND interest <= 5"
      add :remarks, :text
      add :status, :integer, check: "status <= 5"
      timestamps()
    end

    create unique_index(:favorite_jobs, [:user_id, :job_id], name: :favorite_job_user_id_and_job_id_unique_index)
  end
end
