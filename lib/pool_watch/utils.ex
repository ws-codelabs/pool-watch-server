defmodule PoolWatch.Utils do

  def genrate_hash(input \\ nil) do
    input =
      if is_binary(input), do: input, else: Ecto.UUID.autogenerate()

    :crypto.hash(:sha256, input)
    |> Base.encode16()
    |> String.downcase()
  end

  def generate_random_number() do
    "~6..0B"
    |> :io_lib.format([:rand.uniform(1_000_000) - 1])
    |> List.to_string()
  end

end
