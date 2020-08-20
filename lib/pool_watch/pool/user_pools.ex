defmodule PoolWatch.Pool.UserPools do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_pools" do
    field :is_active, :boolean, default: true
    field :priv_key, :string
    field :pub_key, :string

    belongs_to :user, PoolWatch.Account.User
    belongs_to :pool, PoolWatch.Pool.PoolInfo, foreign_key: :pool_id

    timestamps()
  end

  @doc false
  def changeset(user_pools, attrs) do
    user_pools
    |> cast(attrs, [:is_active, :pub_key, :priv_key])
    |> validate_required([:pub_key, :priv_key, :user_id, :pool_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:pool_id)
    |> unique_constraint([:user_id, :pool_id])
  end
end
