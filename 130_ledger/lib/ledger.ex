defmodule Ledger do
  # Changelog:
  # - new prepare_header function
  # - update format_entries to handle the no entries case separately
  # - refactor format_entries with minor internal improvements
  # - new entries_sorter function
  # - new format_date function
  # - new format_amount function
  # - new join_parts function
  # - new format_description function
  # - new prepare_entries function

  @currency_symbols %{eur: "€", usd: "$"}

  @doc """
  Format the given entries given a currency and locale
  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  @spec format_entries(currency(), locale(), list(entry())) :: String.t()
  def format_entries(_currency, locale, []), do: prepare_header(locale) <> "\n"

  def format_entries(currency, locale, entries) do
    prepare_header(locale) <> "\n" <> prepare_entries(currency, locale, entries) <> "\n"
  end

  defp prepare_header(:en_US), do: "Date       | Description               | Change       "
  defp prepare_header(_locale), do: "Datum      | Omschrijving              | Verandering  "

  defp prepare_entries(currency, locale, entries) do
    Enum.sort(entries, &entries_sorter/2)
    |> Enum.map_join("\n", &format_entry(currency, locale, &1))
  end

  defp format_entry(currency, locale, entry) do
    date = format_date(entry.date, locale)
    amount = format_amount(entry.amount_in_cents, locale, currency)
    description = format_description(entry.description)
    Enum.join([date, description, amount], " | ")
  end

  defp entries_sorter(a, b) when a.date.day < b.date.day, do: true
  defp entries_sorter(a, b) when a.date.day > b.date.day, do: false
  defp entries_sorter(a, b) when a.description < b.description, do: true
  defp entries_sorter(a, b) when a.description > b.description, do: false
  defp entries_sorter(a, b), do: a.amount_in_cents <= b.amount_in_cents

  defp format_date(%{month: month, day: day, year: year}, :en_US) do
    :io_lib.format("~2..0B/~2..0B/~4..0B", [month, day, year])
  end

  defp format_date(%{month: month, day: day, year: year}, _locale) do
    :io_lib.format("~2..0B-~2..0B-~4..0B", [day, month, year])
  end

  defp format_amount(amount_in_cents, locale, currency) do
    {dec_sep, whole_sep} = if locale == :en_US, do: {",", "."}, else: {".", ","}
    whole = abs(amount_in_cents) |> div(100)
    decimal = abs(amount_in_cents) |> rem(100)

    whole =
      if whole < 1000, do: "#{whole}", else: "#{div(whole, 1000)}#{dec_sep}#{rem(whole, 1000)}"

    number = :io_lib.format("~s~s~2..0B", [whole, whole_sep, decimal])
    {sep1, sep2, sep3} = separators(locale, amount_in_cents)

    Enum.join([sep1, @currency_symbols[currency], sep2, number, sep3])
    |> String.pad_leading(13, " ")
  end

  defp separators(:en_US, amount_in_cents) when amount_in_cents >= 0, do: {" ", "", " "}
  defp separators(:en_US, _amount_in_cents), do: {"(", "", ")"}
  defp separators(_locale, amount_in_cents) when amount_in_cents >= 0, do: {"", " ", " "}
  defp separators(_locale, _amount_in_cents), do: {"", " -", " "}

  defp format_description(description) do
    if String.length(description) > 26,
      do: String.slice(description, 0, 22) <> "...",
      else: String.pad_trailing(description, 25, " ")
  end
end
