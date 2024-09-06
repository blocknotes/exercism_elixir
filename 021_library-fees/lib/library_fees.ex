defmodule LibraryFees do
  def datetime_from_string(string) do
    with {:ok, datetime} = NaiveDateTime.from_iso8601(string), do: datetime
  end

  def before_noon?(datetime) do
    time = NaiveDateTime.to_time(datetime)
    with {:ok, noon} = Time.new(12, 00, 00), do: Time.before?(time, noon)
  end

  def return_date(checkout_datetime) do
    days = if before_noon?(checkout_datetime), do: 28, else: 29
    with date = NaiveDateTime.to_date(checkout_datetime), do: Date.add(date, days)
  end

  def days_late(planned_return_date, actual_return_datetime) do
    date = NaiveDateTime.to_date(actual_return_datetime)

    with diff = Date.diff(date, planned_return_date),
      do: if(diff > 0, do: diff, else: 0)
  end

  def monday?(datetime) do
    with date = NaiveDateTime.to_date(datetime), do: Date.day_of_week(date) == 1
  end

  def calculate_late_fee(checkout, return, rate) do
    actual_return_datetime = datetime_from_string(return)

    datetime_from_string(checkout)
    |> return_date()
    |> days_late(actual_return_datetime)
    |> then(fn diff ->
      if monday?(actual_return_datetime), do: floor(rate * 0.5 * diff), else: rate * diff
    end)
  end
end
