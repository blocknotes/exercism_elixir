defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(?A), do: "A\n"

  def build_shape(letter) do
    upper_lines = for l <- ?A..letter, do: prepare_line(l, letter)
    lower_lines = for l <- (letter - 1)..?A, do: prepare_line(l, letter)
    Enum.join(upper_lines ++ lower_lines ++ [""], "\n")
  end

  defp prepare_line(l, letter) do
    "~#{letter - l + 1}.. s~#{l - ?A}.. s~#{l - ?A}.. s~#{letter - l}.. s"
    |> :io_lib.format([[l], [?\s], [l], [?\s]])
    |> to_string()
  end
end
