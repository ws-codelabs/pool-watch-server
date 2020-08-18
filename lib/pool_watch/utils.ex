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

  def to_int(value) when is_float(value) do
    Float.to_string(value)
    |> to_int()

  end

  def to_int(value) when is_binary(value) do
    case Integer.parse(value) do
      {v, _} ->
        v

      _ ->
        nil
    end
  end

  def to_float(value) when is_float(value) do
    value
  end

  def to_float(value) when is_integer(value) do
    value * 1.0
  end

  def to_float(value) when is_binary(value) do
    case Float.parse(value) do
      {v, _} ->
        v

      _ ->
        nil
    end
  end

end
