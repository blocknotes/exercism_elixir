defmodule House do
  @sentences [
    ["that ate the", "malt"],
    ["that killed the", "rat"],
    ["that worried the", "cat"],
    ["that tossed the", "dog"],
    ["that milked the", "cow with the crumpled horn"],
    ["that kissed the", "maiden all forlorn"],
    ["that married the", "man all tattered and torn"],
    ["that woke the", "priest all shaven and shorn"],
    ["that kept the", "rooster that crowed in the morn"],
    ["that belonged to the", "farmer sowing his corn"],
    ["", "horse and the hound and the horn"]
  ]

  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop), do: Enum.map_join(start..stop, "", &build_sentence/1)

  defp build_sentence(1), do: "This is the house that Jack built.\n"

  defp build_sentence(number) do
    [_, subject] = Enum.at(@sentences, number - 2)

    @sentences
    |> Enum.slice(0, number - 2)
    |> Enum.reverse()
    |> List.flatten()
    |> then(&["This is the #{subject}" | &1])
    |> Enum.join(" ")
    |> then(&(&1 <> " that lay in the house that Jack built.\n"))
  end
end
