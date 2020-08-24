defmodule PoolWatch.Channel.PoolChannels do
  use Ecto.Schema
  import Ecto.Changeset

  alias PoolWatch.Channel.PoolChannels.Validators

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "pool_channels" do
    field :info, :map
    field :is_active, :boolean, default: true
    field :channel_name, :string, virtual: true

    belongs_to :channel, PoolWatch.Channel.ChannelInfo
    belongs_to :pool, PoolWatch.Pool.PoolInfo
    belongs_to :user, PoolWatch.Account.User

    timestamps()
  end

  @doc false
  def changeset(pool_channels, attrs) do
    pool_channels
    |> cast(attrs, [:info, :is_active, :channel_name])
    |> validate_required([:info, :is_active, :user_id, :channel_id, :pool_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:pool_id)
    |> foreign_key_constraint(:channel_id)
    |> cast_channel_name()
    |> validate_required([:channel_name])
    |> Validators.validate_pool_channel_input()
  end

  defp cast_channel_name(%Ecto.Changeset{valid?: true, data: data} = changeset) do
    updated_data =
      case data do
        %PoolWatch.Channel.PoolChannels{channel_name: name} when is_binary(name) ->
          Map.put(data, :channel_name, String.upcase(name))

        %PoolWatch.Channel.PoolChannels{channel_id: channel_id} ->
          name =
            PoolWatch.Channel.get_channel_info(channel_id)
            |> Map.get(:name)
            |> String.upcase()


          Map.put(data, :channel_name, String.upcase(name))

      end

    changeset
    |> Map.put(:data, updated_data)
  end

  defp cast_channel_name(changeset), do: changeset

end
