defmodule NameBadge do
  def print(id, name, department) do
    prefix = if id, do: "[#{id}] - "
    department = if department, do: String.upcase(department), else: "OWNER"
    "#{prefix}#{name} - #{department}"
  end
end
