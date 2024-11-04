defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(_coins, 0), do: {:ok, []}

  def generate(coins, target) do
    coins = Enum.sort(coins, :desc) |> Enum.filter(&(&1 <= target))
    list = Enum.map(coins, fn _ -> [nil] end)
    result = search_result(coins, target, list)
    if result, do: {:ok, result}, else: {:error, "cannot change"}
  end

  defp search_result(_coins, _target, []), do: nil

  defp search_result(coins, target, list) do
    results = sum_coins(coins, target, list) |> Enum.uniq()
    result = Enum.find_value(results, fn [found | result] -> found && result end)
    result || search_result(coins, target, results)
  end

  defp sum_coins(coins, target, list) do
    for [_ | tail] <- list,
        c <- coins,
        sum = Enum.sum([c | tail]),
        sum <= target,
        do: [sum == target | Enum.sort([c | tail])]
  end
end
