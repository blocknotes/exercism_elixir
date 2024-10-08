defmodule HighSchoolSweetheart do
  def first_letter(name) when is_binary(name) do
    name
    |> String.trim()
    |> String.first()
  end

  def initial(name) when is_binary(name) do
    name
    |> first_letter()
    |> String.upcase()
    |> then(&(&1 <> "."))
  end

  def initials(full_name) when is_binary(full_name) do
    full_name
    |> String.split()
    |> Enum.map(&initial/1)
    |> Enum.join(" ")
  end

  def pair(full_name1, full_name2) do
    i1 = initials(full_name1)
    i2 = initials(full_name2)

    """
         ******       ******
       **      **   **      **
     **         ** **         **
    **            *            **
    **                         **
    **     #{i1}  +  #{i2}     **
     **                       **
       **                   **
         **               **
           **           **
             **       **
               **   **
                 ***
                  *
    """
  end
end
