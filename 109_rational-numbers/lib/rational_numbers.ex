defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a1, b1}, {a2, b2}), do: {a1 * b2 + a2 * b1, b1 * b2} |> reduce()

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({a1, b1}, {a2, b2}), do: {a1 * b2 - a2 * b1, b1 * b2} |> reduce()

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a1, b1}, {a2, b2}), do: {a1 * a2, b1 * b2} |> reduce()

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({a1, b1}, {a2, b2}), do: {a1 * b2, a2 * b1} |> reduce()

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({a1, b1}), do: {Kernel.abs(a1), Kernel.abs(b1)} |> reduce()

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({_a, _b}, 0), do: {1, 1}
  def pow_rational({a, b}, n) when n > 0, do: {a ** n, b ** n} |> reduce()
  def pow_rational({a, b}, n) when n < 0, do: {b ** -n, a ** -n} |> reduce()

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {a, b}), do: nth_root(x ** a, b)

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({0, _b}), do: {0, 1}
  def reduce({a, b}) when b < 0, do: do_reduce({-a, -b})
  def reduce({a, b}), do: do_reduce({a, b})

  defp do_reduce(_r, _n \\ 2)

  defp do_reduce({a, b}, n) when n > Kernel.abs(a) or Kernel.abs(n) > b, do: {a, b}

  defp do_reduce({a, b}, n) when rem(a, n) == 0 and rem(b, n) == 0,
    do: do_reduce({div(a, n), div(b, n)}, n + 1)

  defp do_reduce({a, b}, n), do: do_reduce({a, b}, n + 1)

  defp nth_root(p, q), do: p ** (1 / q)
end
