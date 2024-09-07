defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite([]), do: ""

  def recite(list) when is_list(list),
    do: do_recite(list, "") <> "And all for the want of a #{hd(list)}.\n"

  defp do_recite([_], acc), do: acc

  defp do_recite([something | [other | tail]], acc),
    do: do_recite([other | tail], acc <> "For want of a #{something} the #{other} was lost.\n")
end
