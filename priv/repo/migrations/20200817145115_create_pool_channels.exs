defmodule PoolWatch.Repo.Migrations.CreatePoolChannels do
  use Ecto.Migration

  def change do
    create table(:pool_channels, primary_key: false) do
      add :id, :binary_id, default: fragment("uuid_generate_v4()"), primary_key: true
      add :info, :map, null: false
      add :is_active, :boolean, default: true, null: false

      add :pool_id, references(:pool_infos, on_delete: :delete_all, type: :binary_id)
      add :channel_id, references(:channel_infos, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:pool_channels, [:pool_id])
    create index(:pool_channels, [:channel_id])
    create index(:pool_channels, [:user_id])
  end
end
