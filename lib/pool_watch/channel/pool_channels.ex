defmodule PoolWatch.Channel.PoolChannels do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pool_channels" do
    field :info, :map
    field :is_active, :boolean, default: false
    field :pool_id, :binary_id
    field :channel_id, :binary_id
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(pool_channels, attrs) do
    pool_channels
    |> cast(attrs, [:info, :is_active])
    |> validate_required([:info, :is_active])
  end
end
