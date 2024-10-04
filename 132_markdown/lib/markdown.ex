defmodule Markdown do
  # Changelog:
  # - refactor parse function using pipe operators and with map_join
  # - refactor process function to handle better the conditional checks
  # - use pipe operators where possible
  # - compact enclose_with_header_tag function
  # - compact enclose_with_paragraph_tag function
  # - compact join_words_with_tags function
  # - compact replace_md_with_tag function
  # - compact replace_prefix_md function
  # - compact replace_suffix_md function
  # - compact parse function

  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    String.split(markdown, "\n")
    |> Enum.map_join(&process/1)
    |> patch()
  end

  defp process(t) do
    if String.starts_with?(t, "#######"),
      do: String.split(t) |> enclose_with_paragraph_tag(),
      else: String.first(t) |> do_process(t)
  end

  defp do_process("#", t), do: parse_header_md_level(t) |> enclose_with_header_tag()
  defp do_process("*", t), do: String.trim_leading(t, "* ") |> parse_list_md_level()
  defp do_process(_first_char, t), do: String.split(t) |> enclose_with_paragraph_tag()

  defp parse_header_md_level(hwt) do
    with [h, t] <- String.split(hwt, " ", parts: 2), do: {String.length(h), t}
  end

  defp parse_list_md_level(l),
    do: Enum.join(["<li>", String.split(l) |> join_words_with_tags(), "</li>"])

  defp enclose_with_header_tag({hl, htl}), do: "<h#{hl}>#{htl}</h#{hl}>"

  defp enclose_with_paragraph_tag(t), do: Enum.join(["<p>", join_words_with_tags(t), "</p>"])

  defp join_words_with_tags(t), do: Enum.map_join(t, " ", &replace_md_with_tag/1)

  defp replace_md_with_tag(w), do: replace_prefix_md(w) |> replace_suffix_md()

  defp replace_prefix_md(w) do
    w = String.replace(w, ~r/^#{"__"}{1}/, "<strong>", global: false)
    match_em = ~r/^[#{"_"}{1}][^#{"_"}+]/

    if w =~ match_em, do: String.replace(w, ~r/_/, "<em>", global: false), else: w
  end

  defp replace_suffix_md(w) do
    w = String.replace(w, ~r/#{"__"}{1}$/, "</strong>")
    if w =~ ~r/[^#{"_"}{1}]/, do: String.replace(w, ~r/_/, "</em>"), else: w
  end

  defp patch(l), do: String.replace(l, ~r{<li>(.*)?</li>}, "<ul><li>\\1</li></ul>")
end
