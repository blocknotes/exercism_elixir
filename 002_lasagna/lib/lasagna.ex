defmodule Lasagna do
  def expected_minutes_in_oven, do: 40

  def remaining_minutes_in_oven(minutes) do
    if minutes < expected_minutes_in_oven(), do: expected_minutes_in_oven() - minutes, else: 0
  end

  def preparation_time_in_minutes(layers) do
    if layers > 0, do: layers * 2, else: 0
  end

  def total_time_in_minutes(layers, minutes_in_oven) do
    preparation = preparation_time_in_minutes(layers)
    if minutes_in_oven > 0, do: preparation + minutes_in_oven, else: preparation
  end

  def alarm, do: "Ding!"
end
