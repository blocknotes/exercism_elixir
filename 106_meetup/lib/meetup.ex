defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @month_week %{first: 0, second: 1, third: 2, fourth: 3}
  @weekdays %{monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 7}

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) when is_map_key(@month_week, schedule) do
    Date.new!(year, month, 1 + 7 * @month_week[schedule])
    |> advance_date(weekday)
  end

  def meetup(year, month, weekday, :last) do
    Date.new!(year, month, 1)
    |> Date.end_of_month()
    |> Date.add(-6)
    |> advance_date(weekday)
  end

  def meetup(year, month, weekday, :teenth) do
    Date.new!(year, month, 1)
    |> Date.add(12)
    |> advance_date(weekday)
  end

  defp advance_date(date, weekday) do
    advance = rem(@weekdays[weekday] - Date.day_of_week(date) + 7, 7)
    Date.add(date, advance)
  end
end
