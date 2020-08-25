defmodule PoolWatch.Channel.PoolChannels.Validators do

  alias PoolWatch.Channel.PoolChannels

  import Ecto.Changeset

  def validate_pool_channel_input(%Ecto.Changeset{valid?: true, changes: changes} = changeset) do
    case Map.get(changes, :info) do
      nil ->
        changeset

      _ ->
        validate_change(changeset, :info, fn _, info ->
          case handle_validation(changeset.data, info) do
            {:ok, _} -> []
            {:error, msg} -> [info: msg]
          end
        end)
    end
  end

  def validate_pool_channel_input(changeset), do: changeset

  defp handle_validation(%PoolChannels{channel_name: "DISCORD"} = pool_channel, info) do
    case info do
      %{"web_hook_url" => "https://discordapp.com/api/webhooks/" <> keys } ->
        case String.split(keys, "/") do
          [_key, _secret] ->
            url =  "https://discordapp.com/api/webhooks/" <> keys

            if value_already_exists?(url, Map.from_struct(pool_channel), "web_hook_url") do
              {:error, "DISCORD_WEBHOOKS_ALREADY_EXISTS"}
            else
              {:ok, info}
            end

          _ ->
            {:error, "INVALID_DISCORD_WEBHOOK_URL"}
        end

      _ ->
        {:error, "INVALID_DISCORD_WEBHOOK_URL"}
    end
  end

  defp handle_validation(%PoolChannels{channel_name: "TWITTER"} = pool_channel, info) do
    case info do
      %{"key" => key, "secret" => secret, "username" => username}
        when is_binary(key) and is_binary(secret) and is_binary(username)  ->

          if value_already_exists?(username, Map.from_struct(pool_channel), "username") do
            {:error, "TWITTER_ACCOUNT_ALREADY_ADDED"}
          else
            {:ok, info}
          end

      _ ->
        {:error, "INVALID_TWITTER_USERNAME"}
    end
  end

  defp handle_validation(%PoolChannels{channel_name: "EMAIL"} = pool_channel, info) do
    case info do
      %{"email_address" => email} when is_binary(email) ->

        if value_already_exists?(email, Map.from_struct(pool_channel), "email_address") do
          {:error, "EMAIL_ALREADY_ADDED"}
        else
          {:ok, info}
        end

      _ ->
        {:error, "INVALID_EMAIL"}
    end
  end

  defp handle_validation(_pool_channel, info)  do
      {:ok, info}
  end

  defp value_already_exists?(value, %{user_id: u_id, pool_id: p_id, channel_id: c_id} , key) do
    data =
      Enum.find(PoolWatch.Channel.list_pool_channel(u_id, p_id, c_id), fn %{info: info} ->
        db_data = Map.get(info, key, "")

        String.downcase(db_data) == String.downcase(value)
      end)

    is_map(data)
  end

end
