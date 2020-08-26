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

  def to_int(_), do: nil

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

  def to_float(_), do: nil

  def struct_from_map(a_map, as: a_struct) do
    # Find the keys within the map
    keys =
      Map.keys(a_struct)
      |> Enum.filter(fn x -> x != :__struct__ end)

    processed_map =
      for key <- keys, into: %{} do
          # Process map, checking for both string / atom keys
          value = Map.get(a_map, key) || Map.get(a_map, to_string(key))
          {key, value}
      end

    Map.merge(a_struct, processed_map)
  end


  @doc """
    Converts atom maps to string Map
    ## Examples
      iex> to_string_map(%{a: 1, b: %{c: 1}})
      %{"a" => 1, "b" => %{"c" => 1}}
  """
  def to_string_map(params) when is_map(params) do
    for {k, v} <- params, into: %{} do
      new_key = if is_atom(k), do: Atom.to_string(k), else: k

      if is_map(v) do
        {new_key, to_string_map(v)}

      else
        {new_key, v}
      end
    end
  end

  def to_atom_map(params) when is_map(params) do
    Enum.reduce(params, %{}, fn {k, v}, acc ->
      new_key = if is_binary(k), do: String.to_existing_atom(k), else: k

      if is_map(v) do
        Map.put(acc, new_key, to_atom_map(v))
      else
        Map.put(acc, new_key, v)
      end
    end)
  end

  def to_snake_case(data) when is_binary(data) or is_atom(data) do
    Macro.underscore(data)
  end

  def to_snake_case(data) when is_map(data) do
    for {k, v} <- data, into: %{} do
      if is_map(v) do
        {to_snake_case(k), to_snake_case(v)}
      else
        {to_snake_case(k), v}
      end
    end
  end


end
