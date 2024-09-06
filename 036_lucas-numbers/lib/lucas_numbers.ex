defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """
  def generate(count) when is_integer(count) == false or count < 1,
    do: raise(ArgumentError, "count must be specified as an integer >= 1")

  def generate(1), do: [2]
  def generate(2), do: [2, 1]

  def generate(count) do
    Stream.transform(3..count, [2, 1], fn i, acc ->
      n = Enum.at(acc, i - 3) + Enum.at(acc, i - 2)
      {[n], acc ++ [n]}
    end)
    |> Enum.to_list()
    |> then(&([2, 1] ++ &1))
  end
end
