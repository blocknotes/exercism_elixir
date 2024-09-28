defmodule Yacht do
  @type category ::
          :ones
          | :twos
          | :threes
          | :fours
          | :fives
          | :sixes
          | :full_house
          | :four_of_a_kind
          | :little_straight
          | :big_straight
          | :choice
          | :yacht

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(:ones, dice), do: count_value(dice, 1) * 1
  def score(:twos, dice), do: count_value(dice, 2) * 2
  def score(:threes, dice), do: count_value(dice, 3) * 3
  def score(:fours, dice), do: count_value(dice, 4) * 4
  def score(:fives, dice), do: count_value(dice, 5) * 5
  def score(:sixes, dice), do: count_value(dice, 6) * 6

  def score(:full_house, dice) do
    values = Enum.frequencies(dice) |> Map.values()
    if values in [[2, 3], [3, 2]], do: Enum.sum(dice), else: 0
  end

  def score(:four_of_a_kind, dice) do
    Enum.frequencies(dice) |> Enum.find_value(0, fn {k, v} -> v in [4, 5] and k * 4 end)
  end

  def score(:little_straight, dice) do
    if Enum.sort(dice) == [1, 2, 3, 4, 5], do: 30, else: 0
  end

  def score(:big_straight, dice) do
    if Enum.sort(dice) == [2, 3, 4, 5, 6], do: 30, else: 0
  end

  def score(:choice, dice), do: Enum.sum(dice)
  def score(:yacht, [a, a, a, a, a]), do: 50
  def score(_category, _dice), do: 0

  defp count_value(dice, value), do: Enum.frequencies(dice) |> Map.get(value, 0)
end
