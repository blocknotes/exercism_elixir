defmodule Garden do
  @default_names ~w(alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry)a

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_names) do
    initials = String.replace(info_string, "\n", "")
    students = String.length(initials) |> div(4)
    names = student_names |> Enum.sort()

    plants =
      initials
      |> to_charlist()
      |> Enum.chunk_every(2)
      |> Stream.with_index()
      |> Enum.group_by(fn {_, i} -> rem(i, students) end, fn {[p1, p2], _} ->
        [plant_name(p1), plant_name(p2)]
      end)
      |> Enum.reduce([], fn {_, list}, acc ->
        [Enum.concat(list) |> List.to_tuple() | acc]
      end)
      |> Enum.reverse()

    Enum.zip(names, plants) |> Enum.into(Map.from_keys(names, {}))
  end

  defp plant_name(?C), do: :clover
  defp plant_name(?G), do: :grass
  defp plant_name(?R), do: :radishes
  defp plant_name(?V), do: :violets
end
