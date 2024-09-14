defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?([]), do: true

  def chain?(dominoes) do
    dominoes
    |> do_permutations()
    |> Enum.find(fn permutation ->
      {first, _} = hd(permutation)
      valid_sequence?(permutation, first)
    end)
    |> then(&(not is_nil(&1)))
  end

  defp valid_sequence?([{_, b} | [{b, c} | tail]], acc), do: valid_sequence?([{b, c} | tail], acc)
  defp valid_sequence?([{_, b} | [{c, b} | tail]], acc), do: valid_sequence?([{b, c} | tail], acc)
  defp valid_sequence?([{_, acc}], acc), do: true
  defp valid_sequence?(_, _), do: false

  defp do_permutations([]), do: [[]]

  defp do_permutations(list) do
    for(h <- list, t <- do_permutations(list -- [h]), do: [h | t])
  end
end
