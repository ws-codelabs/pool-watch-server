defmodule PoolWatch.Repo.Migrations.CreateUserPools do
  use Ecto.Migration

  def change do
    create table(:user_pools, primary_key: false) do
      add :id, :binary_id, default: fragment("uuid_generate_v4()"),  primary_key: true
      add :is_active, :boolean, default: false, null: false
      add :pub_key, :string, null: false
      add :priv_key, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :pool_id, references(:pool_infos, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:user_pools, [:user_id])
    create index(:user_pools, [:pool_id])
    create unique_index(:user_pools, [:user_id, :pool_id])
  end
end
