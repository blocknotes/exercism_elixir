defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    text
    |> to_charlist()
    |> Enum.map(fn c ->
      cond do
        c in ?a..?z -> do_rotate(c, shift, ?a)
        c in ?A..?Z -> do_rotate(c, shift, ?A)
        true -> c
      end
    end)
    |> to_string()
  end

  defp do_rotate(c, shift, ref), do: rem(c - ref + shift, 26) + ref
end
