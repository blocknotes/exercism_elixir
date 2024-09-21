defmodule LinkedListNode do
  defstruct [:value, :next]
end

defmodule LinkedList do
  @opaque t :: tuple()

  defstruct [:nodes]

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: %LinkedList{}

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(%LinkedList{nodes: nodes} = list, elem),
    do: %{list | nodes: %LinkedListNode{value: elem, next: nodes}}

  @doc """
  Counts the number of elements in a LinkedList
  """
  @spec count(t) :: non_neg_integer()
  def count(nil), do: 0
  def count(%LinkedList{nodes: nil}), do: 0

  def count(%LinkedList{nodes: %LinkedListNode{next: next}}),
    do: 1 + count(%LinkedList{nodes: next})

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(%LinkedList{nodes: nodes}), do: is_nil(nodes)

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek(%LinkedList{nodes: nil}), do: {:error, :empty_list}
  def peek(%LinkedList{nodes: first_node}), do: {:ok, first_node.value}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail(%LinkedList{nodes: nil}), do: {:error, :empty_list}

  def tail(%LinkedList{nodes: %LinkedListNode{next: next_node}}),
    do: {:ok, %LinkedList{nodes: next_node}}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop(%LinkedList{nodes: nil}), do: {:error, :empty_list}

  def pop(%LinkedList{nodes: %LinkedListNode{value: value, next: next_node}}),
    do: {:ok, value, %LinkedList{nodes: next_node}}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list) when is_list(list) do
    list
    |> Enum.reverse()
    |> Enum.reduce(%LinkedList{nodes: nil}, fn el, acc ->
      push(acc, el)
    end)
  end

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(%LinkedList{nodes: nil}), do: []

  def to_list(%LinkedList{} = list) do
    {:ok, node, tail} = pop(list)
    [node | to_list(tail)]
  end

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(%LinkedList{} = list) do
    list
    |> to_list()
    |> Enum.reverse()
    |> from_list()
  end
end
