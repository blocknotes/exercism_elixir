defmodule Username do
  def sanitize([]), do: ~c""
  def sanitize([head | tail]), do: filter(head) ++ sanitize(tail)

  defp filter(char) do
    case char do
      ?ä -> ~c"ae"
      ?ö -> ~c"oe"
      ?ü -> ~c"ue"
      ?ß -> ~c"ss"
      ?_ -> ~c"_"
      char when char >= ?a and char <= ?z -> [char]
      _ -> ~c""
    end
  end
end
