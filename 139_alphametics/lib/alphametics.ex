defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

    iex> Alphametics.solve("I + BB == ILL")
    %{?I => 1, ?B => 9, ?L => 0}

    iex> Alphametics.solve("A == B")
    nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    [operands, result, letters] = split_input(puzzle)
    first_operands_letter = List.first(operands) |> List.first()
    first_result_letter = List.first(result)

    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    |> permutations(length(letters), {})
    |> Enum.find_value(fn numbers ->
      numbers = Tuple.to_list(numbers)
      map = Enum.zip(letters, numbers) |> Map.new()

      if map[first_operands_letter] != 0 and map[first_result_letter] != 0 do
        left = Enum.map(operands, &prepare_number(&1, map)) |> Enum.sum()
        right = prepare_number(result, map)
        if left == right, do: map
      end
    end)
  end

  defp split_input(input) do
    [operands, result] = String.replace(input, " ", "") |> String.split("==")
    [split_operands(operands), to_charlist(result), uniq_letters(input)]
  end

  defp split_operands(operands), do: String.split(operands, "+") |> Enum.map(&to_charlist/1)

  defp uniq_letters(string) do
    string
    |> String.replace(~r/[^\w]/, "")
    |> to_charlist()
    |> Enum.uniq()
  end

  defp permutations(_, 0, acc), do: acc

  defp permutations(list, size, acc) do
    result = for el <- list, do: permutations(list -- [el], size - 1, Tuple.append(acc, el))
    List.flatten(result)
  end

  defp prepare_number(list, map) do
    Enum.reverse(list)
    |> Enum.with_index()
    |> Enum.map(fn {n, i} -> map[n] * 10 ** i end)
    |> Enum.sum()
  end

  # ----------------------------------------------------------------------- #
  # Alternative version using string replacement

  # def solve(puzzle) do
  #   [operands, result] = String.replace(puzzle, " ", "") |> String.split("==")
  #   letters = uniq_letters(puzzle)
  #   chars = Enum.join(letters) |> to_charlist()
  #   operands1 = Regex.run(~r/./, operands) |> List.first()
  #   result1 = Regex.run(~r/./, result) |> List.first()

  #   solution =
  #     permutations(~w[0 1 2 3 4 5 6 7 8 9], length(letters), {})
  #     |> Enum.find(fn perm ->
  #       numbers = Tuple.to_list(perm)
  #       map = Enum.zip(letters, numbers) |> Map.new()

  #       if map[operands1] != "0" and map[result1] != "0" do
  #         sum = convert(operands, letters, map)
  #         tot = convert(result, letters, map)
  #         sum == tot
  #       else
  #         false
  #       end
  #     end)

  #   if solution do
  #     values = Tuple.to_list(solution) |> Enum.map(&String.to_integer/1)
  #     Enum.zip(chars, values) |> Map.new()
  #   end
  # end

  # defp convert(string, letters, map) do
  #   string
  #   |> String.replace(letters, &map[&1])
  #   |> String.split("+")
  #   |> Enum.map(&String.to_integer/1)
  #   |> Enum.sum()
  # end
end
