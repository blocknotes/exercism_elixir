defmodule OcrNumbers do
  @digits %{
    [" _ ", "| |", "|_|", "   "] => "0",
    ["   ", "  |", "  |", "   "] => "1",
    [" _ ", " _|", "|_ ", "   "] => "2",
    [" _ ", " _|", " _|", "   "] => "3",
    ["   ", "|_|", "  |", "   "] => "4",
    [" _ ", "|_ ", " _|", "   "] => "5",
    [" _ ", "|_ ", "|_|", "   "] => "6",
    [" _ ", "  |", "  |", "   "] => "7",
    [" _ ", "|_|", "|_|", "   "] => "8",
    [" _ ", "|_|", " _|", "   "] => "9"
  }

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    with {:ok, count} <- count_digits(input) do
      Enum.chunk_every(input, 4)
      |> Enum.map_join(",", fn chunk -> process_input(chunk, count) |> Enum.join() end)
      |> then(&{:ok, &1})
    end
  end

  defp count_digits(input) when rem(length(input), 4) != 0, do: {:error, "invalid line count"}

  defp count_digits(input) do
    len = List.first(input) |> String.length()
    if rem(len, 3) != 0, do: {:error, "invalid column count"}, else: {:ok, div(len, 3)}
  end

  defp process_input(input, count) do
    input
    |> Enum.flat_map(&Regex.scan(~r{...}, &1))
    |> Enum.with_index()
    |> Enum.group_by(fn {_, i} -> rem(i, count) end, fn {p, _} -> Enum.join(p) end)
    |> Enum.map(fn {_i, digit} -> Map.get(@digits, digit, "?") end)
  end
end
