defmodule PoolWatch.Pool do
  @moduledoc """
  The Pool context.
  """

  import Ecto.Query, warn: false
  alias PoolWatch.Repo

  alias PoolWatch.Pool.Info
  alias PoolWatch.Account.User

  @doc """
  Returns the list of pool_infos.

  ## Examples

      iex> list_pool_infos()
      [%Info{}, ...]

  """
  def list_pool_infos do
    Repo.all(Info)
  end

  @doc """
  Gets a single info.

  Raises `Ecto.NoResultsError` if the Info does not exist.

  ## Examples

      iex> get_info!(123)
      %Info{}

      iex> get_info!(456)
      ** (Ecto.NoResultsError)

  """
  def get_info!(id), do: Repo.get!(Info, id)


  @doc """
    Search pool with several params

    ## Examples

      iex> search_pool(valid_query)
      %Info{}

      iex> search_pool(invalid_query)
      nil
  """
  def search_pool(query) do
    query =
      from p in Info,
      where: p.hash == ^query or p.metadata_hash == ^query,
      select: p

    Repo.one(query)
  end

  @doc """
  Creates a info.

  ## Examples

      iex> create_pool(%{field: value})
      {:ok, %Info{}}

      iex> create_pool(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pool(attrs \\ %{}) do
    %Info{}
    |> Info.changeset(attrs)
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
    IO.inspect pool_data

    Repo.insert_all(Info, pool_data, [
      on_conflict: :replace_all,
      conflict_target: "hash"
    ])
  end

  @doc """
  Updates a info.

  ## Examples

      iex> update_info(info, %{field: new_value})
      {:ok, %Info{}}

      iex> update_info(info, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_info(%Info{} = info, attrs) do
    info
    |> Info.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a info.

  ## Examples

      iex> delete_info(info)
      {:ok, %Info{}}

      iex> delete_info(info)
      {:error, %Ecto.Changeset{}}

  """
  def delete_info(%Info{} = info) do
    Repo.delete(info)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking info changes.

  ## Examples

      iex> change_info(info)
      %Ecto.Changeset{data: %Info{}}

  """
  def change_info(%Info{} = info, attrs \\ %{}) do
    Info.changeset(info, attrs)
  end

  alias PoolWatch.Pool.UserPools

  @doc """
    Assigns Pool to user

    ## Examples

        iex> create_user_pools(%User{}, %Info{})
        {:ok, %UserPools{}}

        iex> create_user_pools(%User{is_verified: false}, pool_info)
        {:error, :USER_NOT_VERIFIED}

        iex> create_user_pools(invalid_user, pool_info)
        {:error, :INVALID_USER}

        iex> create_user_pools(user, invalid_pool_info)
        {:error, :INVALID_POOL}

  """
  def create_user_pools(%User{is_verified: false}, _pool_info), do: {:error, :USER_NOT_VERIFIED}
  def create_user_pools(%User{id: user_id}, %Info{id: pool_id}) do
    attrs = %{
      pub_key: "pb_" <> PoolWatch.Utils.genrate_hash(),
      priv_key: "secret_" <> PoolWatch.Utils.genrate_hash()
    }
    %UserPools{user_id: user_id, pool_id: pool_id}
    |> UserPools.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_pools(_, %Info{}), do: {:error, :INVALID_USER}
  def create_user_pools(_, _), do: {:error, :INVALID_POOL}


end
