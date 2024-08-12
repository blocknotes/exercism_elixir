defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    if hourly_rate > 0, do: hourly_rate * 8.0, else: 0.0
  end

  def apply_discount(before_discount, discount) do
    if before_discount > 0 and discount >= 0 and discount <= 100,
      do: before_discount * (1 - discount * 0.01),
      else: 0.0
  end

  def monthly_rate(hourly_rate, discount) do
    (22 * daily_rate(hourly_rate))
    |> apply_discount(discount)
    |> ceil()
  end

  def days_in_budget(budget, hourly_rate, discount) do
    daily_rate(hourly_rate)
    |> apply_discount(discount)
    |> then(fn daily -> Float.floor(budget / daily, 1) end)
  end
end
