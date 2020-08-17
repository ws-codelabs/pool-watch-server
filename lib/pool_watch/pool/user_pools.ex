defmodule PoolWatch.Pool.UserPools do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_pools" do
    field :is_active, :boolean, default: false
    field :priv_key, :string
    field :pub_key, :string
    field :user_id, :binary_id
    field :pool_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(user_pools, attrs) do
    user_pools
    |> cast(attrs, [:is_active, :pub_key, :priv_key])
    |> validate_required([:pub_key, :priv_key])
  end
end
