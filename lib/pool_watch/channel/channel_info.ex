defmodule PoolWatch.Channel.ChannelInfo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "channel_infos" do
    field :inputs, {:array, :map}
    field :is_active, :boolean, default: true
    field :logo, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(channel_info, attrs) do
    channel_info
    |> cast(attrs, [:name, :logo, :inputs, :is_active])
    |> validate_required([:name, :inputs])
    |> unique_constraint(:name)
  end
end
