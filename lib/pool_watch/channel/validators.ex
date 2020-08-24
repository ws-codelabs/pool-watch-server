defmodule PoolWatch.Channel.PoolChannels.Validators do

  alias PoolWatch.Channel.PoolChannels

  import Ecto.Changeset

  def validate_pool_channel_input(%Ecto.Changeset{valid?: true} = changeset) do
    validate_change(changeset, :info, fn _, info ->
      case handle_validation(changeset.data, info) do
        {:ok, _} -> []
        {:error, msg} -> [info: msg]
      end
    end)

  end

  def validate_pool_channel_input(changeset), do: changeset

  defp handle_validation(%PoolChannels{channel_name: "DISCORD"}, info) do
    case info do
      %{"web_hook_url" => "https://discordapp.com/api/webhooks/" <> keys } ->
        case String.split(keys, "/") do
          [_key, _secret] ->
            {:ok, info}

          _ ->
            {:error, "INVALID_DISCORD_URL"}
        end

      _ ->
        {:error, "INVALID_DISCORD_URL"}
    end
  end

  defp handle_validation(%PoolChannels{channel_name: "TWITTER"} = pool_channel, info) do
    case info do
      %{"key" => key, "secret" => secret, "username" => username}
        when is_binary(key) and is_binary(secret) and is_binary(username)  ->
          if twitter_already_exists?(username, Map.from_struct(pool_channel)) do
            {:error, "TWITTER_ALREADY_ADDED"}
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
        if email_already_exists?(email, Map.from_struct(pool_channel)) do
          {:error, "EMAIL_ALREADY_EXISTS"}

        else
          {:ok, info}
        end

      _ ->
        {:error, "INVALID_USER_NAME"}
    end
  end

  defp handle_validation(_pool_channel, info)  do
      {:ok, info}
  end

  defp twitter_already_exists?(uname, %{user_id: u_id, pool_id: p_id, channel_id: c_id}) do
    data =
      Enum.find(PoolWatch.Channel.list_pool_channel(u_id, p_id, c_id), fn %{info: info} ->
        db_username = Map.get(info, "username", "")
        String.downcase(db_username) == String.downcase(uname)
      end)

    is_map(data)
  end



  defp email_already_exists?(email, %{user_id: u_id, pool_id: p_id, channel_id: c_id}) do
    data =
      Enum.find(PoolWatch.Channel.list_pool_channel(u_id, p_id, c_id), fn %{info: info} ->
        db_email = Map.get(info, "email_address", "")
        String.downcase(db_email) == String.downcase(email)
      end)

    is_map(data)
  end

end
