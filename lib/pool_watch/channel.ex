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
    Repo.all(ChannelInfo)
  end

  @doc """
  Gets a single channel_info.

  Raises `Ecto.NoResultsError` if the Channel info does not exist.

  ## Examples

      iex> get_channel_info!(123)
      %ChannelInfo{}

      iex> get_channel_info!(456)
      ** (Ecto.NoResultsError)

  """
  def get_channel_info!(id), do: Repo.get!(ChannelInfo, id)

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
  alias PoolWatch.Pool.UserPools
  alias PoolWatch.Account.User

  def list_pool_channel(%User{id: user_id}, pool_id) when is_binary(pool_id) do
    query =
      from pc in PoolChannels,
      where: pc.user_id == ^user_id and pc.pool_id == ^pool_id,
      select: pc

    Repo.all(query)
  end

  def list_pool_channel(%User{id: user_id}, pool_ids) when is_list(pool_ids) do
    query =
      from pc in PoolChannels,
      where: pc.user_id == ^user_id and pc.pool_id in ^pool_ids,
      select: pc

    Repo.all(query)
  end


  def change_pool_status(%PoolChannels{} = pool_channels, status) do
    pool_channels
    |> PoolChannels.changeset(%{is_active: status})
    |> Repo.update()
  end

end
