defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(_, size) when size < 1, do: []

  def slices(s, size) do
    length = String.length(s)

    if size <= length do
      for i <- 0..(length - size), do: String.slice(s, i, size)
    else
      []
    end
  end
end
