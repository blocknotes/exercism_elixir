defmodule Squares do
  @moduledoc """
  Calculate sum of squares, square of sum, difference between two sums from 1 to a given end number.
  """

  @doc """
  Calculate sum of squares from 1 to a given end number.
  """
  @spec sum_of_squares(pos_integer) :: pos_integer
  def sum_of_squares(number) do
    with {_, total} <- calc_sum_of_squares(number), do: total
  end

  @doc """
  Calculate square of sum from 1 to a given end number.
  """
  @spec square_of_sum(pos_integer) :: pos_integer
  def square_of_sum(number), do: div(number * (number + 1), 2) ** 2

  @doc """
  Calculate difference between sum of squares and square of sum from 1 to a given end number.
  """
  @spec difference(pos_integer) :: pos_integer
  def difference(number), do: square_of_sum(number) - sum_of_squares(number)

  defp calc_sum_of_squares(number) do
    Enum.reduce(1..number, {0, 0}, fn i, {partial, total} ->
      partial = partial + (2 * i - 1)
      {partial, partial + total}
    end)
  end
end
