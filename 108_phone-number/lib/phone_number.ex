defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    raw
    |> String.replace(~r/\A(1|\+1)|[\s\.-]/, "")
    |> then(fn number ->
      with {:ok} <- check_length(number),
           {:ok, {area_code, exchange_code}} <- check_parts(number),
           do: {:ok, area_code <> exchange_code}
    end)
  end

  defp check_length(number) do
    len = number |> String.replace(~r/[^0-9]/, "") |> String.length()

    cond do
      number =~ ~r/[^0-9()]+/ -> {:error, "must contain digits only"}
      len == 11 -> {:error, "11 digits must start with 1"}
      len < 10 -> {:error, "must not be fewer than 10 digits"}
      len > 11 -> {:error, "must not be greater than 11 digits"}
      true -> {:ok}
    end
  end

  defp check_parts(number) do
    [_, area_code, exchange_code] = Regex.run(~r/\((\d+)\)(\d+)/, number) || [nil, "", number]
    area_code1 = String.at(area_code, 0)
    exchange_code1 = String.at(exchange_code, 0)

    cond do
      area_code1 == "0" -> {:error, "area code cannot start with zero"}
      area_code1 == "1" -> {:error, "area code cannot start with one"}
      exchange_code1 == "0" -> {:error, "exchange code cannot start with zero"}
      exchange_code1 == "1" -> {:error, "exchange code cannot start with one"}
      true -> {:ok, {area_code, exchange_code}}
    end
  end
end
