defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct [:white, :black]

  @doc """
  Creates a new set of Queens
  """
  @spec new(Keyword.t()) :: Queens.t()
  def new(opts \\ []), do: struct(Queens, validate_opts!(opts))

  @doc """
  Gives a string representation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(%Queens{black: black, white: white}) do
    Enum.map(1..64, fn _ -> "_" end)
    |> update_position(black, "B")
    |> update_position(white, "W")
    |> Enum.chunk_every(8)
    |> Enum.map_join("\n", &Enum.join(&1, " "))
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{black: nil}), do: false
  def can_attack?(%Queens{white: nil}), do: false

  def can_attack?(%Queens{black: {br, bc}, white: {wr, wc}}),
    do: br == wr or bc == wc or br - bc == wr - wc or br + bc == wr + wc

  defp validate_opts!(opts) do
    if invalid_position?(opts[:black]) or invalid_position?(opts[:white]) or
         opts[:black] == opts[:white] or Keyword.keys(opts) -- [:black, :white] != [],
       do: raise(ArgumentError, "Invalid argument")

    opts
  end

  defp invalid_position?(nil), do: false
  defp invalid_position?({r, c}), do: c < 0 or r < 0 or c > 7 or r > 7

  defp update_position(board, nil, _symbol), do: board
  defp update_position(board, {r, c}, symbol), do: List.replace_at(board, r * 8 + c, symbol)
end
