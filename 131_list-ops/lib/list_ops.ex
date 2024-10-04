defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count([]), do: 0
  def count([_head | tail]), do: 1 + count(tail)

  @spec reverse(list) :: list
  def reverse(list), do: do_reverse(list, [])

  @spec map(list, (any -> any)) :: list
  def map([], _fun), do: []
  def map([head | tail], fun), do: [fun.(head) | map(tail, fun)]

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], _fun), do: []

  def filter([head | tail], fun) do
    if fun.(head), do: [head | filter(tail, fun)], else: filter(tail, fun)
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, _fun), do: acc
  def foldl([head | tail], acc, fun), do: foldl(tail, fun.(head, acc), fun)

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(list, acc, fun), do: reverse(list) |> foldl(acc, fun)

  @spec append(list, list) :: list
  def append(a, b), do: reverse(a) |> do_append(b)

  @spec concat([[any]]) :: [any]
  def concat(lists) do
    reverse(lists)
    |> do_concat()
    |> reverse()
  end

  defp do_reverse([], acc), do: acc
  defp do_reverse([head | tail], acc), do: do_reverse(tail, [head | acc])

  defp do_append([], b), do: b
  defp do_append([head | tail], b), do: do_append(tail, [head | b])

  defp do_concat([]), do: []
  defp do_concat([head | tail]), do: do_append(head, do_concat(tail))
end
