defmodule PoolWatch.Pool.Info do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pool_infos" do
    field :description, :string
    field :fixed_cost, :integer
    field :hash, :string
    field :home_url, :string
    field :margin, :float
    field :metadata_hash, :string
    field :pledge, :integer
    field :reward_address, :string
    field :ticker, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(info, attrs) do
    info
    |> cast(attrs, [:url, :metadata_hash, :hash, :pledge, :margin, :fixed_cost, :reward_address, :ticker, :home_url, :description])
    |> validate_required([:metadata_hash, :hash])
  end
end
