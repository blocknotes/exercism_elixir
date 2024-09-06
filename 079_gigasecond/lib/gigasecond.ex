defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          {{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}
  def from({{year, month, day}, {hours, minutes, seconds}}) do
    with {:ok, ndt} = NaiveDateTime.new(year, month, day, hours, minutes, seconds) do
      ndt
      |> NaiveDateTime.add(1_000_000_000)
      |> NaiveDateTime.to_erl()
    end
  end
end
