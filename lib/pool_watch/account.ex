defmodule PoolWatch.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias PoolWatch.Repo

  alias PoolWatch.Account.User
  alias PoolWatch.Account.TokenRegistry

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user({:email, email}), do: Repo.get_by(User, email: email)
  def get_user(id) when is_binary(id), do: Repo.get(User, id)
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
    validates code and Logins user

    ## Examples

      iex> login(valid_code)
      {:ok, %{user_info: %User{}, token: token}}

      iex> login(invalid_code)
      {:error,  :INVALID_CODE || :CODE_EXPIRED}
  """
  def login(code) when is_binary(code) do
    case TokenRegistry.check_user(code) do
      {:ok, %{email: email}} ->
        create_or_fetch_user(%{email: email, is_verified: true})
        |> generate_token()

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp generate_token({:ok, user}) do
    {:ok, token, _} = PoolWatch.Account.Guardian.encode_and_sign(user)
    {:ok, %{user_info: user, token: token}}
  end

  defp generate_token(result), do: result

  @doc """
    Creates or fetch User

    iex> create_or_fetch_user(valid_attrs)
    {:ok , %User{}}

    iex> create_or_fetch_user(invalid_attrs)
    {:error, %Ecto.Changeset{}}

  """
  def create_or_fetch_user(%{email: email} = user_params) do
    case get_user({:email, email}) do
      nil ->
        create_user(user_params)

      user ->
        {:ok, user}
    end
  end



  alias PoolWatch.Account.UserDevices

  @doc """
    creates Mobile Device_id for user

    ## Examples

        iex> create_user_device(%User{}, valid_attrs)
        {:ok, %UserDevice{}}

        iex> create_user_device(%user{}, invalid_attrs)
        {:error, %Ecto.Changeset{}}

        iex> create_user_device(_, _)
        {:error, :INVALID_USER}

  """
  def create_user_device(%User{id: id}, attrs) do
    %UserDevices{user_id: id}
    |> UserDevices.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_device(_invalid_user, _attrs), do: {:error, :INVALID_USER}

  alias PoolWatch.Account.UserToken

  def create_user_token(user) do
    create_user_token(user, %{})
  end
  def create_user_token(%User{id: user_id}, attrs) do
    %UserToken{user_id: user_id}
    |> UserToken.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_token(_invalid_user, _attrs ), do: {:error, :INVALID_USER}

  def send_token_email(%User{email: email}, opts) do
    content = Keyword.get(opts, :content)
    subject = Keyword.get(opts, :subject)
    data = Keyword.get(opts, :data)

    PoolWatch.Email.html_email(email, subject, content: content, data: data)
    |> PoolWatch.Mailer.deliver_later()
  end

  def send_token_email(email, opts) do
    %User{email: email}
    |> send_token_email(opts)
  end

end
