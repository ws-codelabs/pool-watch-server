defmodule PoolWatch.Account.TokenRegistryTest do
  use PoolWatch.DataCase

  test "user_auth test" do

    assert {:ok, code} = PoolWatch.Account.TokenRegistry.handle_new_user("e@e.com")
    assert {:ok, info} = PoolWatch.Account.TokenRegistry.check_user(code)

    assert info.email == "e@e.com"
    assert {:error, :CODE_EXPIRED} == PoolWatch.Account.TokenRegistry.check_user(code, 0)
    assert {:error, :INVALID_CODE} == PoolWatch.Account.TokenRegistry.check_user("bad-code", 0)

  end
end
