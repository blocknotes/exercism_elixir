defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}
  def build_tree(preorder, inorder) do
    cond do
      different_length?(preorder, inorder) -> {:error, "traversals must have the same length"}
      different_elements?(preorder, inorder) -> {:error, "traversals must have the same elements"}
      repeated_items?(preorder) -> {:error, "traversals must contain unique items"}
      repeated_items?(inorder) -> {:error, "traversals must contain unique items"}
      true -> {:ok, do_build(inorder, preorder) |> to_tuple()}
    end
  end

  defp different_length?(preorder, inorder), do: length(preorder) != length(inorder)
  defp different_elements?(preorder, inorder), do: Enum.sort(preorder) != Enum.sort(inorder)
  defp repeated_items?(list), do: length(list) != Enum.uniq(list) |> length()

  defp do_build(acc, []), do: acc
  defp do_build(acc, [head | tail]), do: split_by(head, acc) |> do_build(tail)

  defp split_by(head, list) do
    cond do
      not is_list(list) -> list
      head in list -> Enum.chunk_by(list, &(&1 == head))
      true -> Enum.map(list, &split_by(head, &1))
    end
  end

  defp to_tuple([left, center, right]), do: {to_tuple(left), to_tuple(center), to_tuple(right)}
  defp to_tuple([[item]]), do: {{}, to_tuple(item), {}}
  defp to_tuple([item]), do: to_tuple(item)
  defp to_tuple([]), do: {}
  defp to_tuple(item), do: item
end
