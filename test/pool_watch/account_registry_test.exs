defmodule PoolWatch.Account.TokenRegistryTest do
  use PoolWatch.DataCase

  test "user_auth test" do

    assert {:ok, code} = PoolWatch.TokenRegistry.handle_new_user("e@e.com")
    assert {:ok, info} = PoolWatch.TokenRegistry.check_user(code)

    assert info.email == "e@e.com"
    assert {:error, :CODE_EXPIRED} == PoolWatch.TokenRegistry.check_user(code, 0)
    assert {:error, :INVALID_CODE} == PoolWatch.TokenRegistry.check_user("bad-code", 0)

  end
end
