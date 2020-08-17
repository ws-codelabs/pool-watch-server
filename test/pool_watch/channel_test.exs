defmodule PoolWatch.ChannelTest do
  use PoolWatch.DataCase

  alias PoolWatch.Channel

  describe "channel_infos" do
    alias PoolWatch.Channel.ChannelInfo

    @valid_attrs %{inputs: [%{}], is_active: true, logo: "some logo", name: "some name"}
    @update_attrs %{inputs: [%{}], is_active: false, logo: "some updated logo", name: "some updated name"}
    @invalid_attrs %{inputs: nil, is_active: nil, logo: nil, name: nil}

    def channel_info_fixture(attrs \\ %{}) do
      {:ok, channel_info} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Channel.create_channel_info()

      channel_info
    end

    test "list_channel_infos/0 returns all channel_infos" do
      channel_info = channel_info_fixture()
      assert Channel.list_channel_infos() == [channel_info]
    end

    test "get_channel_info!/1 returns the channel_info with given id" do
      channel_info = channel_info_fixture()
      assert Channel.get_channel_info!(channel_info.id) == channel_info
    end

    test "create_channel_info/1 with valid data creates a channel_info" do
      assert {:ok, %ChannelInfo{} = channel_info} = Channel.create_channel_info(@valid_attrs)
      assert channel_info.inputs == [%{}]
      assert channel_info.is_active == true
      assert channel_info.logo == "some logo"
      assert channel_info.name == "some name"
    end

    test "create_channel_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channel.create_channel_info(@invalid_attrs)
    end

    test "update_channel_info/2 with valid data updates the channel_info" do
      channel_info = channel_info_fixture()
      assert {:ok, %ChannelInfo{} = channel_info} = Channel.update_channel_info(channel_info, @update_attrs)
      assert channel_info.inputs == [%{}]
      assert channel_info.is_active == false
      assert channel_info.logo == "some updated logo"
      assert channel_info.name == "some updated name"
    end

    test "update_channel_info/2 with invalid data returns error changeset" do
      channel_info = channel_info_fixture()
      assert {:error, %Ecto.Changeset{}} = Channel.update_channel_info(channel_info, @invalid_attrs)
      assert channel_info == Channel.get_channel_info!(channel_info.id)
    end

    test "delete_channel_info/1 deletes the channel_info" do
      channel_info = channel_info_fixture()
      assert {:ok, %ChannelInfo{}} = Channel.delete_channel_info(channel_info)
      assert_raise Ecto.NoResultsError, fn -> Channel.get_channel_info!(channel_info.id) end
    end

    test "change_channel_info/1 returns a channel_info changeset" do
      channel_info = channel_info_fixture()
      assert %Ecto.Changeset{} = Channel.change_channel_info(channel_info)
    end
  end
end
