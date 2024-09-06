defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    string
    |> to_charlist()
    |> Enum.chunk_by(& &1)
    |> Enum.map_join(fn chunk ->
      l = length(chunk)
      c = chunk |> to_string() |> String.first()
      if l > 1, do: "#{l}#{c}", else: c
    end)
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    Regex.scan(~r/(\d+)([a-zA-Z ])|([a-zA-Z ])/, string)
    |> Enum.map_join(fn part ->
      case part do
        [_, l, c] -> String.duplicate(c, String.to_integer(l))
        [_, "", "", c] -> c
      end
    end)
  end
end
