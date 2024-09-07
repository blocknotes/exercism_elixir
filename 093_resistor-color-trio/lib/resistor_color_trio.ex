defmodule ResistorColorTrio do
  @doc """
  Calculate the resistance value in ohms from resistor colors
  """
  @spec label(colors :: [atom]) :: {number, :ohms | :kiloohms | :megaohms | :gigaohms}
  def label([color1, color2, color3 | _]) do
    value = (values_map()[color1] * 10 + values_map()[color2]) * 10 ** values_map()[color3]

    cond do
      (v = div(value, 1000_000_000)) > 0 -> {v, :gigaohms}
      (v = div(value, 1000_000)) > 0 -> {v, :megaohms}
      (v = div(value, 1000)) > 0 -> {v, :kiloohms}
      true -> {value, :ohms}
    end
  end

  defp values_map do
    %{
      black: 0,
      brown: 1,
      red: 2,
      orange: 3,
      yellow: 4,
      green: 5,
      blue: 6,
      violet: 7,
      grey: 8,
      white: 9
    }
  end
end
