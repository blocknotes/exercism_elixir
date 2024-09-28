defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1)
  def generate(max_factor, min_factor) when min_factor > max_factor, do: raise(ArgumentError)

  def generate(max_factor, min_factor) do
    palindrome_product_factors(max_factor, min_factor)
    |> Enum.group_by(fn {prod, _factors} -> prod end, fn {_prod, factors} -> factors end)
  end

  defp palindrome_product_factors(max_factor, min_factor) do
    for i <- min_factor..max_factor,
        j <- min_factor..max_factor,
        j >= i,
        product = i * j,
        digits = Integer.digits(product),
        palindrome?(digits),
        do: {product, [i, j]}
  end

  defp palindrome?(digits), do: digits == Enum.reverse(digits)
end
