defmodule CustomSet do
  @opaque t :: %__MODULE__{map: map}

  defstruct map: []

  @spec new(Enum.t()) :: t
  def new([]), do: %CustomSet{}

  def new(enumerable) do
    enumerable
    |> Enum.uniq()
    |> Enum.sort()
    |> then(&%CustomSet{map: &1})
  end

  @spec empty?(t) :: boolean
  def empty?(%CustomSet{map: map}), do: map == []

  @spec contains?(t, any) :: boolean
  def contains?(%CustomSet{map: map}, element), do: element in map

  @spec subset?(t, t) :: boolean
  def subset?(%CustomSet{map: map1}, %CustomSet{map: map2}), do: map1 -- map2 == []

  @spec disjoint?(t, t) :: boolean
  def disjoint?(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    map1 -- map1 -- map2 == [] and map2 -- map2 -- map1 == []
  end

  @spec equal?(t, t) :: boolean
  def equal?(%CustomSet{map: map1}, %CustomSet{map: map2}), do: map1 == map2

  @spec add(t, any) :: t
  def add(%CustomSet{map: map}, element), do: CustomSet.new([element | map])

  @spec intersection(t, t) :: t
  def intersection(%CustomSet{map: map1}, %CustomSet{map: map2}) do
    %CustomSet{map: map1 -- map1 -- map2}
  end

  @spec difference(t, t) :: t
  def difference(%CustomSet{map: map1}, %CustomSet{map: map2}), do: %CustomSet{map: map1 -- map2}

  @spec union(t, t) :: t
  def union(%CustomSet{map: map1}, %CustomSet{map: map2}), do: CustomSet.new(map1 ++ map2)
end
