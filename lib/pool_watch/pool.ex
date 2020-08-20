defmodule PoolWatch.Pool do
  @moduledoc """
  The Pool context.
  """

  import Ecto.Query, warn: false
  alias PoolWatch.Repo

  alias PoolWatch.Pool.PoolInfo
  alias PoolWatch.Account.User

  @doc """
  Returns the list of pool_infos.

  ## Examples

      iex> list_pool_infos()
      [%PoolInfo{}, ...]

  """
  def list_pool_infos do
    Repo.all(PoolInfo)
  end

  @doc """
  Gets a single info.

  Raises `Ecto.NoResultsError` if the Info does not exist.

  ## Examples

      iex> get_info(123)
      %PoolInfo{}

      iex> get_info(456)
      nil

  """
  def get_info(id), do: Repo.get(PoolInfo, id)


  @doc """
    Search pool with several params

    ## Examples

      iex> search_pool(valid_query)
      %PoolInfo{}

      iex> search_pool(invalid_query)
      nil
  """
  def search_pool(query) do
    query =
      from p in PoolInfo,
      where: p.hash == ^query or p.metadata_hash == ^query,
      select: p

    Repo.one(query)
  end

  @doc """
  Creates a info.

  ## Examples

      iex> create_pool(%{field: value})
      {:ok, %PoolInfo{}}

      iex> create_pool(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pool(attrs \\ %{}) do
    %PoolInfo{}
    |> PoolInfo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Fetches all pools from blockchain and stores them
  """
  def sync_pools() do
    PoolWatch.Query.StakePoolQuery.list_all_stake_pool()
    |> insert_all_pool()
  end

  @doc """
    Inserts multiple pool at one go
  """
  def insert_all_pool(pool_data) do
    Repo.insert_all(PoolInfo, pool_data, [
      on_conflict: :replace_all,
      conflict_target: "hash"
    ])
  end

  @doc """
  Updates a info.

  ## Examples

      iex> update_info(info, %{field: new_value})
      {:ok, %PoolInfo{}}

      iex> update_info(info, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_info(%PoolInfo{} = pool_info, attrs) do
    pool_info
    |> PoolInfo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a info.

  ## Examples

      iex> delete_info(info)
      {:ok, %PoolInfo{}}

      iex> delete_info(info)
      {:error, %Ecto.Changeset{}}

  """
  def delete_info(%PoolInfo{} = info) do
    Repo.delete(info)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking info changes.

  ## Examples

      iex> change_info(info)
      %Ecto.Changeset{data: %PoolInfo{}}

  """
  def change_info(%PoolInfo{} = info, attrs \\ %{}) do
    PoolInfo.changeset(info, attrs)
  end

  alias PoolWatch.Pool.UserPools

  @doc """
    Assigns Pool to user

    ## Examples

        iex> create_user_pools(%User{}, %PoolInfo{})
        {:ok, %UserPools{}}

        iex> create_user_pools(%User{is_verified: false}, pool_info)
        {:error, :USER_NOT_VERIFIED}

        iex> create_user_pools(invalid_user, pool_info)
        {:error, :INVALID_USER}

        iex> create_user_pools(user, invalid_pool_info)
        {:error, :INVALID_POOL}

  """
  def create_user_pools(%User{is_verified: false}, _pool_info), do: {:error, :USER_NOT_VERIFIED}
  def create_user_pools(%User{id: user_id}, %PoolInfo{id: pool_id}) do
    attrs = %{
      pub_key: "pb_" <> PoolWatch.Utils.genrate_hash(),
      priv_key: "secret_" <> PoolWatch.Utils.genrate_hash()
    }
    %UserPools{user_id: user_id, pool_id: pool_id}
    |> UserPools.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_pools(_, %PoolInfo{}), do: {:error, :INVALID_USER}
  def create_user_pools(_, _), do: {:error, :INVALID_POOL}

  @doc """
    gives lists of user pools

    ## Examples

        iex> list_user_pools(%User{})
        [%UserPools{}]

        iex> list_user_pools(invalid_user)
        []

  """

  def list_user_pools(%User{id: user_id}) do
    query =
      from up in UserPools,
      where: up.user_id == ^user_id,
      preload: [:pools],
      select: up

    Repo.all(query)
  end

  def list_user_pools(_), do: []

  @doc """
    Returns user_pool detail

    ## Examples

        iex> get_user_pool(%User{}, valid_pool_id)
        %UserPools{}

        iex> get_user_pool(user, invalid_id)
        nil

  """
  def get_user_pool(%User{id: user_id}, user_pool_id) when is_binary(user_pool_id) do
    Repo.get_by(UserPools, user_id: user_id, id: user_pool_id)
  end

  def get_user_pool(_, _), do: nil

  @doc """
    Updates User Pool

    ## Examples

        iex> update_user_pool(%UserPools{}, valid_attrs)
        {:ok, %UserPools{}}

        iex> update_user_pool(%UserPools{}, invalid_attrs)
        {:error, %Ecto.Changeset{}}

        iex> update_user_pool(invalid_user_pool, attrs)
        {:error, :INVALID_USER_POOL}

  """
  def update_user_pool(%UserPools{} = user_pool, attrs) do
    user_pool
    |> UserPools.changeset(attrs)
    |> Repo.update()
  end

  def update_user_pool(_, _), do: {:error, :INVALID_USER_POOL}

  def change_user_pool_status(user_pool, status) do
    update_user_pool(user_pool, %{is_active: status})
  end

  @doc """
    Removes user_pools

    ## Examples

        iex> delete_user_pools(%UserPools{})
        {:ok, %UserPools{}}

        iex> delete_user_pools(invalid_user_pool)
        {:error, :INVALID_USER_POOL}

  """
  def delete_user_pools(%UserPools{} = user_pool) do
    Repo.delete(user_pool)
  end

  def delete_user_pools(_), do: {:error, :INVALID_USER_POOL}


end
