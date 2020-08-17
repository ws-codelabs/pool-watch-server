defmodule PoolWatch.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\" WITH SCHEMA public;"

    create table(:users, primary_key: false) do
      add :id, :binary_id, default: fragment("uuid_generate_v4()"), primary_key: true
      add :email, :string, null: false
      add :mob_no, :string
      add :is_active, :boolean, default: true, null: false
      add :profile, :map
      add :role, :string, null: false, default: "NORMAL"

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
