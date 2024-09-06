defmodule BoutiqueInventory do
  def sort_by_price(inventory), do: Enum.sort_by(inventory, & &1.price)

  def with_missing_price(inventory), do: Enum.filter(inventory, &is_nil(&1.price))

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn item ->
      updated_name = String.replace(item.name, old_word, new_word)
      %{item | name: updated_name}
    end)
  end

  def increase_quantity(item, count) do
    new_quantities = Map.new(item.quantity_by_size, fn {s, q} -> {s, q + count} end)
    %{item | quantity_by_size: new_quantities}
  end

  def total_quantity(item),
    do: Enum.reduce(item.quantity_by_size, 0, fn {_, q}, acc -> acc + q end)
end
