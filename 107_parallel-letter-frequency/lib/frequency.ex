defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _workers), do: %{}

  def frequency(texts, workers) do
    texts
    |> Enum.chunk_every(ceil(length(texts) / workers))
    |> Enum.map(fn list ->
      Task.async(fn -> letter_frequency(list) end)
    end)
    |> Enum.reduce([], fn task, acc -> [process_task_result(task) | acc] end)
    |> Enum.concat()
    |> Enum.group_by(fn {k, _} -> k end, fn {_, v} -> v end)
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.put_new(acc, k, v |> Enum.sum())
    end)
  end

  defp letter_frequency(texts) do
    Enum.map(texts, fn text ->
      text
      |> String.downcase()
      |> String.replace(~r/[0-9\s\(\)\?\\!'",.:;-]/, "")
      |> String.graphemes()
      |> Enum.frequencies()
    end)
  end

  defp process_task_result(task) do
    Task.await(task)
    |> Enum.flat_map(&Map.to_list/1)
  end
end
