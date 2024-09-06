defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) when a == b, do: :equal

  def compare(a, b) when length(a) < length(b) do
    if contains?(a, b), do: :sublist, else: :unequal
  end

  def compare(a, b) do
    if contains?(b, a), do: :superlist, else: :unequal
  end

  defp contains?(_, []), do: false
  defp contains?(a, b), do: List.starts_with?(b, a) || contains?(a, tl(b))
end
