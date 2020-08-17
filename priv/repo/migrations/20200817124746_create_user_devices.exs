defmodule PoolWatch.Repo.Migrations.CreateUserDevices do
  use Ecto.Migration

  def change do
    create table(:user_devices, primary_key: false) do
      add :id, :binary_id, default: fragment("uuid_generate_v4()"),  primary_key: true
      add :device_id, :string, null: false
      add :device_type, :string, null: false
      add :is_active, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:user_devices, [:user_id])
    create unique_index(:user_devices, [:device_id])
  end
end
