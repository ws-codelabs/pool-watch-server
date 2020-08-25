defmodule PoolWatch.PoolChannelValidatorTest do
  use PoolWatch.DataCase

  alias PoolWatch.Channel
  alias PoolWatch.Pool

  setup do
    {:ok, user_pools} = Pool.create_user_pools(get_user(), get_pool())
    {:ok, %{user_pools: user_pools}}
  end

  describe "Twitter Validation test" do
    @valid_twitter %{
      info: %{"key" => "t_key", "secret" => "s_key", "username" => "u1"},
      is_active: true
    }

    @invalid_twitter %{
      info: %{"key" => "t_key", "secret" => "s_key"}
    }

    @update_state %{
      is_active: false
    }

    @update_with_username %{
      info: %{"key" => "t_key", "secret" => "new_sec_key", "username" => "u1"}
    }

    test "create twitter channel", %{user_pools: u_pool} do
      c_info = Channel.get_channel_info({:name, "Twitter"})
      assert {:ok, _twitter} = Channel.create_pool_channel(u_pool, c_info, @valid_twitter)
      assert {:error, changeset} = Channel.create_pool_channel(u_pool, c_info, @invalid_twitter)
      assert errors_on(changeset).info == ["INVALID_TWITTER_USERNAME"]

      assert {:error, changeset} = Channel.create_pool_channel(u_pool, c_info, @valid_twitter)
      assert errors_on(changeset).info == ["TWITTER_ACCOUNT_ALREADY_ADDED"]

    end

    test "update twitter channel", %{user_pools: u_pool} do
      c_info = Channel.get_channel_info({:name, "Twitter"})
      assert {:ok, twitter} = Channel.create_pool_channel(u_pool, c_info, @valid_twitter)

      assert {:error, changeset} = Channel.update_pool_channel(twitter, @update_with_username)
      assert errors_on(changeset).info == ["TWITTER_ACCOUNT_ALREADY_ADDED"]

      assert {:error, changeset} = Channel.update_pool_channel(twitter, @invalid_twitter)
      assert errors_on(changeset).info == ["INVALID_TWITTER_USERNAME"]

      assert {:ok, updated_twitter} = Channel.update_pool_channel(twitter, @update_state)
      assert updated_twitter.id == twitter.id
      assert  updated_twitter.info ==  twitter.info
      assert updated_twitter.is_active == @update_state.is_active

    end
  end

  describe "Discord validation Test" do
    @valid_discord %{
      info: %{"web_hook_url" => "https://discordapp.com/api/webhooks/api_key/channel_id"},
      is_active: true
    }

    @invalid_discord %{
      info: %{"web_hook_url" => "https://discordapp.com/api/webhooks/"}
    }

    @update_state %{
      is_active: false
    }

    test "create discord channel", %{user_pools: u_pool} do
      c_info = Channel.get_channel_info({:name, "Discord"})
      assert {:ok, _discord} = Channel.create_pool_channel(u_pool, c_info, @valid_discord)
      assert {:error, changeset} = Channel.create_pool_channel(u_pool, c_info, @invalid_discord)
      assert errors_on(changeset).info == ["INVALID_DISCORD_WEBHOOK_URL"]

      assert {:error, changeset} = Channel.create_pool_channel(u_pool, c_info, @valid_discord)
      assert errors_on(changeset).info == ["DISCORD_WEBHOOKS_ALREADY_EXISTS"]
    end

    test "update discord channel", %{user_pools: u_pool} do
      c_info = Channel.get_channel_info({:name, "Discord"})
      assert {:ok, discord} = Channel.create_pool_channel(u_pool, c_info, @valid_discord)

      assert {:error, changeset} = Channel.update_pool_channel(discord, @invalid_discord)
      assert errors_on(changeset).info == ["INVALID_DISCORD_WEBHOOK_URL"]

      assert {:ok, updated_discord} = Channel.update_pool_channel(discord, @update_state)
      assert updated_discord.id == discord.id
      assert updated_discord.is_active == @update_state.is_active

    end
  end

  describe "Email validation Test" do
    @valid_email %{
      info: %{"email_address" => "email@e.com"},
      is_active: true
    }

    # @invalid_email %{
    #   info: %{"email_address" => "bad_email"}
    # }

    @update_state %{
      is_active: false
    }

    test "create email channel", %{user_pools: u_pool} do
      c_info = Channel.get_channel_info({:name, "Email"})
      assert {:ok, _email} = Channel.create_pool_channel(u_pool, c_info, @valid_email)
      # assert {:error, changeset} = Channel.create_pool_channel(u_pool, c_info, @invalid_email)
      # assert errors_on(changeset).info == ["INVALID_EMAIL"]

      assert {:error, changeset} = Channel.create_pool_channel(u_pool, c_info, @valid_email)
      assert errors_on(changeset).info == ["EMAIL_ALREADY_ADDED"]
    end

    test "update email channel", %{user_pools: u_pool} do
      c_info = Channel.get_channel_info({:name, "Email"})
      assert {:ok, email} = Channel.create_pool_channel(u_pool, c_info, @valid_email)

      # assert {:error, changeset} = Channel.update_pool_channel(email, @invalid_email)
      # assert errors_on(changeset).info == ["INVALID_EMAIL"]

      assert {:ok, updated_email} = Channel.update_pool_channel(email, @update_state)
      assert updated_email.id == email.id
      assert updated_email.is_active == @update_state.is_active

    end
  end

end
