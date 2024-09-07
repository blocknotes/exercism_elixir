defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number) when number < 1,
    do: {:error, "Classification is only possible for natural numbers."}

  def classify(number) when number <= 2, do: {:ok, :deficient}

  def classify(number) do
    aliquot_sum = factors(1, div(number, 2), number, []) |> Enum.sum()

    cond do
      aliquot_sum < number -> {:ok, :deficient}
      aliquot_sum > number -> {:ok, :abundant}
      true -> {:ok, :perfect}
    end
  end

  defp factors(i, j, n, acc) when rem(n, i) == 0, do: factors(i + 1, j, n, [i | acc])
  defp factors(i, j, n, acc) when i <= j, do: factors(i + 1, j, n, acc)
  defp factors(_, _, _, acc), do: acc
end
