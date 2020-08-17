defmodule PoolWatch.Utils do

  def genrate_hash() do
    :crypto.hash(:sha256, Ecto.UUID.autogenerate())
    |> Base.encode16()
    |> String.downcase()
  end
end
