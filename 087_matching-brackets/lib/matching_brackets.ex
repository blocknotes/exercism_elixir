defmodule MatchingBrackets do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> String.replace(~r/[^()\[\]{}]/, "")
    |> String.graphemes()
    |> valid_brackets?([])
  end

  defp valid_brackets?(["(" = head | tail], acc), do: valid_brackets?(tail, [head | acc])
  defp valid_brackets?(["[" = head | tail], acc), do: valid_brackets?(tail, [head | acc])
  defp valid_brackets?(["{" = head | tail], acc), do: valid_brackets?(tail, [head | acc])
  defp valid_brackets?([")" | tail], ["(" | acc]), do: valid_brackets?(tail, acc)
  defp valid_brackets?(["]" | tail], ["[" | acc]), do: valid_brackets?(tail, acc)
  defp valid_brackets?(["}" | tail], ["{" | acc]), do: valid_brackets?(tail, acc)
  defp valid_brackets?([], []), do: true
  defp valid_brackets?(_, _), do: false
end
