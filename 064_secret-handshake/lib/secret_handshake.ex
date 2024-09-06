defmodule SecretHandshake do
  @moduledoc false

  @actions ["wink", "double blink", "close your eyes", "jump"]

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    digits = Integer.digits(code, 2) |> Enum.reverse()

    @actions
    |> Stream.with_index()
    |> Enum.reduce([], fn {action, i}, acc ->
      if Enum.at(digits, i) == 1, do: [action | acc], else: acc
    end)
    |> then(fn result ->
      if Enum.at(digits, length(@actions)) == 1, do: result, else: result |> Enum.reverse()
    end)
  end
end
