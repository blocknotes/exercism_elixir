defmodule KitchenCalculator do
  def get_volume({unit, value})
      when unit in [:milliliter, :cup, :fluid_ounce, :teaspoon, :tablespoon] do
    value * 1.0
  end

  def to_milliliter({:milliliter, value}), do: {:milliliter, value * 1.0}

  def to_milliliter({:cup, value}), do: {:milliliter, value * 240.0}

  def to_milliliter({:fluid_ounce, value}), do: {:milliliter, value * 30.0}

  def to_milliliter({:teaspoon, value}), do: {:milliliter, value * 5.0}

  def to_milliliter({:tablespoon, value}), do: {:milliliter, value * 15.0}

  def from_milliliter({:milliliter, value}, target_unit) do
    with {_, k} <- to_milliliter({target_unit, 1}), do: {target_unit, value / k}
  end

  def convert(volume_pair, target_unit) do
    volume_pair
    |> to_milliliter()
    |> from_milliliter(target_unit)
  end
end
