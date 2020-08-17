defmodule PoolWatch.AccountTest do
  use PoolWatch.DataCase

  alias PoolWatch.Account

  describe "users" do
    alias PoolWatch.Account.User

    @valid_attrs %{email: "some email", is_active: true, mob_no: "some mob_no", profile: %{}, role: "some role"}
    @update_attrs %{email: "some updated email", is_active: false, mob_no: "some updated mob_no", profile: %{}, role: "some updated role"}
    @invalid_attrs %{email: nil, is_active: nil, mob_no: nil, profile: nil, role: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.is_active == true
      assert user.mob_no == "some mob_no"
      assert user.profile == %{}
      assert user.role == "some role"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.is_active == false
      assert user.mob_no == "some updated mob_no"
      assert user.profile == %{}
      assert user.role == "some updated role"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "user devices" do
    alias Account.UserDevices

    @valid_attrs %{
      device_id: "valid_device_id",
      device_type: "ANDROID"
    }

    test "create_user_device/2" do
      assert {:ok, %UserDevices{}} = Account.create_user_device(get_user(), @valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Account.create_user_device(get_user(), @valid_attrs)
      assert {:error, :INVALID_USER} == Account.create_user_device(nil, %{})
      assert {:error, %Ecto.Changeset{}} = Account.create_user_device(get_user(), %{})
    end
  end

  describe "user token test" do
    alias Account.UserToken

    @valid_attrs %{
      type: "TYPE-01"
    }

    test "create_user_token creates token for user" do
      assert {:ok, %UserToken{token: token, code: code}} = Account.create_user_token(get_user())
      assert is_binary(token)
      assert is_binary(code)

      assert {:error, :INVALID_USER} == Account.create_user_token(nil, %{})
      assert {:ok, %UserToken{type: type}} = Account.create_user_token(get_user(), @valid_attrs)
      assert type == @valid_attrs.type
    end
  end
end
