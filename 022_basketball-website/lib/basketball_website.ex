defmodule BasketballWebsite do
  def extract_from_path(data, path) do
    with parts = String.split(path, "."), do: do_extract_from_path(data, parts)
  end

  def get_in_path(data, path) do
    with parts = String.split(path, "."), do: get_in(data, parts)
  end

  defp do_extract_from_path(data, []), do: data
  defp do_extract_from_path(data, [head | tail]), do: do_extract_from_path(data[head], tail)
end
