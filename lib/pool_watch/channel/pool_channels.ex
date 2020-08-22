defmodule PoolWatch.Channel.PoolChannels do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pool_channels" do
    field :info, :map
    field :is_active, :boolean, default: true

    belongs_to :channel, PoolWatch.Channel.ChannelInfo
    belongs_to :pool, PoolWatch.Pool.PoolInfo
    belongs_to :user, PoolWatch.Account.User

    timestamps()
  end

  @doc false
  def changeset(pool_channels, attrs) do
    pool_channels
    |> cast(attrs, [:info, :is_active])
    |> validate_required([:info, :is_active, :user_id, :channel_id, :pool_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:pool_id)
    |> foreign_key_constraint(:channel_id)
  end
end
