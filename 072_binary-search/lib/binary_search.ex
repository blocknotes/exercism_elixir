defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    Tuple.to_list(numbers) |> do_search(key, 0)
  end

  defp do_search([key], key, pos), do: {:ok, pos}
  defp do_search([], _, _), do: :not_found
  defp do_search([_], _, _), do: :not_found

  defp do_search(list, key, pos) do
    [a, b] = Enum.chunk_every(list, ceil(length(list) / 2))
    if key < hd(b), do: do_search(a, key, pos), else: do_search(b, key, pos + length(a))
  end
end
