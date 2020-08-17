defmodule PoolWatch.Account.UserToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_tokens" do
    field :token, :string
    field :type, :string, default: "AUTH"
    field :user_id, :binary_id
    field :code, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(usertoken, attrs) do
    usertoken
    |> cast(attrs, [:type])
    |> cast_code()
    |> cast_token()
    |> validate_required([:token, :type, :code])
    |> unique_constraint(:token)
  end

  defp cast_code(changeset) do
    put_change(changeset, :code, PoolWatch.Utils.generate_random_number())
  end

  defp cast_token(%Ecto.Changeset{changes: %{code: code}} = changeset) when is_binary(code) do
    changeset
    |> put_change(:token, PoolWatch.Utils.genrate_hash(code))
  end

  defp cast_token(changeset), do: changeset
end
