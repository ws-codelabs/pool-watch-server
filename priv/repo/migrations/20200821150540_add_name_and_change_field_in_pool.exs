defmodule PoolWatch.Repo.Migrations.AddNameAndChangeFieldInPool do
  use Ecto.Migration

  def change do
    alter table(:pool_infos) do
      add :name, :string
      add :additional_info, :map
    end
  end
end
