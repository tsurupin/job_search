defmodule Customer.Repo.Migrations.CreateGuardianDb do
  use Ecto.Migration

  def change do
    create table(:guardian_tokens, primary_key: false) do
      add :jti, :string, primary_key: true
      add :aud, :string
      add :iss, :string
      add :sub, :string
      add :exp, :bigint
      add :jwt, :text
      add :claims, :map
      add :typ, :string

      timestamps()
    end

    create index(:guardian_tokens, [:typ])
  end
end
