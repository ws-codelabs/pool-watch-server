defmodule PoolWatch.Repo.Migrations.CreateChannelInfos do
  use Ecto.Migration

  def change do
    create table(:channel_infos, primary_key: false) do
      add :id, :binary_id, default: fragment("uuid_generate_v4()"), primary_key: true
      add :name, :string, null: false
      add :logo, :string
      add :inputs, {:array, :map}, null: false
      add :is_active, :boolean, default: true, null: false

      timestamps()
    end

    create unique_index(:channel_infos, [:name])
  end
end
