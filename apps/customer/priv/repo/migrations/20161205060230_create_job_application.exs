defmodule Customer.Repo.Migrations.CreateJobApplication do
  use Ecto.Migration

  def change do
    create table(:job_applications) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :job_id, references(:jobs, on_delete: :delete_all)
      add :status, :integer, default: 0, null: false, check: "status <= 5"
      add :comment, :text
      timestamps()
    end

    create unique_index(:job_applications, [:user_id, :job_id, :status], name: :job_applications_application_unique_index)
    create index(:job_applications, [:user_id, :status])
  end
end
