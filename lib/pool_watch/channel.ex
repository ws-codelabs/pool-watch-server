defmodule PoolWatch.Channel do
  @moduledoc """
  The Channel context.
  """

  import Ecto.Query, warn: false
  alias PoolWatch.Repo

  alias PoolWatch.Channel.ChannelInfo

  @doc """
  Returns the list of channel_infos.

  ## Examples

      iex> list_channel_infos()
      [%ChannelInfo{}, ...]

  """
  def list_channel_infos do
    query =
      from c in ChannelInfo,
      where: c.is_active == true,
      select: c

    Repo.all(query)
  end

  @doc """
  Gets a single channel_info.

  Raises `Ecto.NoResultsError` if the Channel info does not exist.

  ## Examples

      iex> get_channel_info(123)
      %ChannelInfo{}

      iex> get_channel_info(invalid_id)
      nil


  """
  def get_channel_info(id) when is_binary(id), do: Repo.get(ChannelInfo, id)

  def get_channel_info({:name, name}), do: Repo.get_by(ChannelInfo, name: name)

  @doc """
  Creates a channel_info.

  ## Examples

      iex> create_channel_info(%{field: value})
      {:ok, %ChannelInfo{}}

      iex> create_channel_info(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_channel_info(attrs \\ %{}) do
    %ChannelInfo{}
    |> ChannelInfo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a channel_info.

  ## Examples

      iex> update_channel_info(channel_info, %{field: new_value})
      {:ok, %ChannelInfo{}}

      iex> update_channel_info(channel_info, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_channel_info(%ChannelInfo{} = channel_info, attrs) do
    channel_info
    |> ChannelInfo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a channel_info.

  ## Examples

      iex> delete_channel_info(channel_info)
      {:ok, %ChannelInfo{}}

      iex> delete_channel_info(channel_info)
      {:error, %Ecto.Changeset{}}

  """
  def delete_channel_info(%ChannelInfo{} = channel_info) do
    Repo.delete(channel_info)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking channel_info changes.

  ## Examples

      iex> change_channel_info(channel_info)
      %Ecto.Changeset{data: %ChannelInfo{}}

  """
  def change_channel_info(%ChannelInfo{} = channel_info, attrs \\ %{}) do
    ChannelInfo.changeset(channel_info, attrs)
  end

  alias PoolWatch.Channel.PoolChannels
  alias PoolWatch.Account.User
  alias PoolWatch.Pool.UserPools
  alias PoolWatch.Channel.ChannelInfo

  @doc """
    gives list of pool channel

    ## Examples

        iex> list_pool_channel(%User{}, valid_pool_id)
        [%PoolChannels{}]

        iex> list_pool_channel(%User{}, invalid_pool_id)
        []

        iex> list_pool_channel(%User{}, list_of_ids)
        [%PoolChannels{}]

  """
  def list_pool_channel(%User{id: user_id}, pool_id) when is_binary(pool_id) do
    query =
      from pc in PoolChannels,
      where: pc.user_id == ^user_id and pc.pool_id == ^pool_id,
      preload: [:pool],
      select: pc

    Repo.all(query)
  end

  def list_pool_channel(%User{id: user_id}, pool_ids) when is_list(pool_ids) do
    query =
      from pc in PoolChannels,
      where: pc.user_id == ^user_id and pc.pool_id in ^pool_ids,
      preload: [:pool],
      select: pc

    Repo.all(query)
  end

  @doc """
    Creates new pool channel

    ## Examples

        iex> create_pool_channel(%UserPools{}, %ChannelInfo{}, valid_attrs)
        {:ok, %PoolChannels{}}

        iex> create_pool_channel(%UserPools{}, %ChannelInfo{}, invalid_attrs)
        {:ok, %PoolChannels{}}

  """
  def create_pool_channel(%UserPools{user_id: u_id, pool_id: p_id}, %ChannelInfo{id: id}, attrs) do
    %PoolChannels{user_id: u_id, pool_id: p_id, channel_id: id}
    |> PoolChannels.changeset(attrs)
    |> Repo.insert()
  end

  def create_pool_channel(_, %ChannelInfo{}, _attrs), do: {:error, :INVALID_USER_POOL}

  def create_pool_channel(_, _, _attrs), do: {:error, :INVALID_CHANNEL}

  def get_pool_channel(%User{id: user_id}, id) do
    Repo.get_by(PoolChannels, user_id: user_id, id: id)
  end

  def update_pool_channel(%PoolChannels{} = pool_channel, attrs) do
    pool_channel
    |> PoolChannels.changeset(attrs)
    |> Repo.update()
  end

  def update_pool_channel(_, _), do: {:error, :INVALID_POOL_CHANNEL}

  def delete_pool_channel(%PoolChannels{} = pool_channel) do
    Repo.delete(pool_channel)
  end

  def delete_pool_channel(_), do: {:error, :INVALID_POOL_CHANNEL}

  def change_pool_status(%PoolChannels{} = pool_channels, status) do
    pool_channels
    |> PoolChannels.changeset(%{is_active: status})
    |> Repo.update()
  end

end
