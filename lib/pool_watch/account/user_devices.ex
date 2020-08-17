defmodule PoolWatch.Account.UserDevices do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_devices" do
    field :device_id, :string
    field :device_type, :string
    field :is_active, :boolean, default: true
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(user_devices, attrs) do
    user_devices
    |> cast(attrs, [:device_id, :device_type, :is_active])
    |> validate_required([:device_id, :device_type, :is_active])
    |> unique_constraint(:device_id)
  end
end
