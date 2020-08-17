defmodule PoolWatch.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :mob_no, :string
    field :profile, :map
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :mob_no, :is_active, :profile, :role])
    |> validate_required([:email, :mob_no, :is_active, :profile, :role])
  end
end
