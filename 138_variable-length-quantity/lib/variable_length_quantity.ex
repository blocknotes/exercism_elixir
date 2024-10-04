defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers),
    do: Enum.reduce(integers, <<>>, fn integer, acc -> acc <> encode_integer(integer) end)

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(<<byte>>) when byte < 128, do: {:ok, [byte]}

  def decode(bytes) do
    result = :binary.bin_to_list(bytes) |> do_decode()
    if result == [], do: {:error, "incomplete sequence"}, else: {:ok, Enum.reverse(result)}
  end

  defp encode_integer(integer) when integer < 128, do: <<integer>>

  defp encode_integer(integer) do
    [head | tail] = convert_base(integer, 128)

    Enum.map(tail, &(&1 + 128))
    |> List.insert_at(0, head)
    |> Enum.reverse()
    |> Enum.into(<<>>, &<<&1>>)
  end

  defp convert_base(value, base) when value < base, do: [value]
  defp convert_base(value, base), do: [rem(value, base) | div(value, base) |> convert_base(base)]

  defp do_decode(list) do
    Enum.reduce(list, [[]], &append_byte/2)
    |> tl()
    |> Enum.map(&(List.pop_at(&1, -1) |> decode_number()))
  end

  defp append_byte(el, [head | tail]) when el < 128, do: [[] | [head ++ [el] | tail]]
  defp append_byte(el, [head | tail]), do: [head ++ [el] | tail]

  defp decode_number({part1, part2}) do
    Enum.reverse(part2)
    |> List.insert_at(0, part1 + 128)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {number, index}, acc -> acc + (number - 128) * 128 ** index end)
  end
end
