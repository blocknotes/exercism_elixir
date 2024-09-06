defmodule BinarySearchTree do
  @type bst_node :: %{data: any, left: bst_node | nil, right: bst_node | nil}

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data), do: %{data: data, left: nil, right: nil}

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(tree, data) do
    path = do_insert_path(tree, data, []) |> Enum.reverse()
    Kernel.put_in(tree, path, __MODULE__.new(data))
  end

  defp do_insert_path(tree, data, acc) when data <= tree.data do
    if tree.left, do: do_insert_path(tree.left, data, [:left | acc]), else: [:left | acc]
  end

  defp do_insert_path(tree, data, acc) do
    if tree.right, do: do_insert_path(tree.right, data, [:right | acc]), else: [:right | acc]
  end

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(nil), do: []
  def in_order(tree), do: Enum.concat([in_order(tree.left), [tree.data], in_order(tree.right)])
end
