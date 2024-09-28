defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) when radicand > 0 do
    d = shift_l(1, 30) |> div4(radicand)
    sqrt(radicand, radicand, 0, d)
  end

  defp sqrt(_n, _x, c, 0), do: c
  defp sqrt(n, x, c, d) when x >= c + d, do: sqrt(n, x - (c + d), shift_r(c) + d, shift_r(d, 2))
  defp sqrt(n, x, c, d), do: sqrt(n, x, shift_r(c), shift_r(d, 2))

  defp div4(d, n) when d <= n, do: d
  defp div4(d, n), do: div4(shift_r(d, 2), n)

  defp shift_l(n, bits), do: Bitwise.<<<(n, bits)
  defp shift_r(n, bits \\ 1), do: Bitwise.>>>(n, bits)
end
