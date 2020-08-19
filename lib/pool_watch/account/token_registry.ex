defmodule PoolWatch.TokenRegistry do
  use GenServer

  alias PoolWatch.Utils
  alias PoolWatch.Account

  @default_interval 10 * 60
  @default_type "USER_AUTH"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_new_user(email) when is_binary(email) do
    code = Utils.generate_random_number()
    GenServer.cast(__MODULE__, {:new_user, Utils.genrate_hash(code), email, @default_type})

    Account.send_token_email(email,
      data: %{code: code},
      content: "auth_code.html",
      subject: "PoolWatch: Auth Code: #{code}"
    )

    {:ok, code}
  end

  def handle_new_user(_), do: {:error, :INVALID_EMAIL}

  def check_user(code, interval \\ @default_interval) do
    GenServer.call(__MODULE__, {:check_code, Utils.genrate_hash(code), @default_type, interval })
  end



  @impl true
  def init(_opts) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:new_user, code, email, type}, state) do
    key = code <> type
    {:noreply,  Map.put(state, key, %{type: type, email: email, created_at: DateTime.utc_now()})}
  end

  @impl true
  def handle_call({:check_code, code, type, interval}, _from,  state) do
    key = code <> type
    response =
      case Map.get(state, key) do
        %{created_at: created_at} = data  ->
            if NaiveDateTime.diff(NaiveDateTime.utc_now(), created_at) < interval do
              {:ok, data}

            else
              {:error, :CODE_EXPIRED}
            end

        _ ->
          {:error, :INVALID_CODE}
      end

    {:reply, response, state}
  end


end
