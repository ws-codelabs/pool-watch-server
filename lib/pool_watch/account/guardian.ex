defmodule PoolWatch.Account.Guardian do
  use Guardian, otp_app: :pool_watch

  alias PoolWatch.Account

  def subject_for_token(user, _claims) do
    {:ok, user.id}
  end

  def resource_from_claims(%{"sub" => id}) do
    {:ok, Account.get_user(id)}
  end

  def fetch_user_from_token(token) when is_binary(token) do
    case PoolWatch.Account.Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        resource_from_claims(claims)

      _ ->
        {:error, :INVALID_TOKEN}
    end
  end

  def fetch_user_from_token(_token) do
    {:error, :INVALID_TOKEN}
  end
end
