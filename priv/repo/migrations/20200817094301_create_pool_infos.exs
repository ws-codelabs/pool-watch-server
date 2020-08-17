defmodule PoolWatch.Repo.Migrations.CreatePoolInfos do
  use Ecto.Migration

  def change do
    create table(:pool_infos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :metadata_hash, :string
      add :hash, :string
      add :pledge, :integer
      add :margin, :float
      add :fixed_cost, :integer
      add :reward_address, :string
      add :ticker, :string
      add :home_url, :string
      add :description, :text

      timestamps()
    end

  end
end
