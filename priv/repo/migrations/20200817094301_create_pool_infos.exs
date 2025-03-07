defmodule PoolWatch.Repo.Migrations.CreatePoolInfos do
  use Ecto.Migration

  def change do
    create table(:pool_infos, primary_key: false) do
      add :id, :binary_id, default: fragment("uuid_generate_v4()"), primary_key: true
      add :url, :string
      add :metadata_hash, :string, null: false
      add :hash, :string, nulll: false
      add :pledge, :bigint
      add :margin, :float
      add :fixed_cost, :bigint
      add :reward_address, :string
      add :ticker, :string
      add :home_url, :string
      add :description, :text

      timestamps()
    end

    create unique_index(:pool_infos, :hash)
  end
end
