defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) when is_binary(pattern) and is_list(flags) and is_list(files) do
    options = prepare_options(flags)

    cond do
      options.filenames_only ->
        Enum.filter(files, fn filename ->
          filename
          |> readlines()
          |> Enum.find(false, fn line -> match_pattern?(line, pattern, options) end)
        end)
        |> then(&(&1 ++ [""]))
        |> Enum.join("\n")

      length(files) > 1 ->
        Enum.map_join(files, fn filename ->
          filename
          |> readlines()
          |> do_content_search(pattern, options)
          |> Enum.map_join(fn result -> "#{filename}:#{result}" end)
        end)

      true ->
        files
        |> List.first()
        |> readlines()
        |> do_content_search(pattern, options)
        |> Enum.join()
    end
  end

  defp prepare_options(flags) do
    %{}
    |> then(fn options -> Map.put_new(options, :case_insensitive, "-i" in flags) end)
    |> then(fn options -> Map.put_new(options, :filenames_only, "-l" in flags) end)
    |> then(fn options -> Map.put_new(options, :invert_search, "-v" in flags) end)
    |> then(fn options -> Map.put_new(options, :match_entire_line, "-x" in flags) end)
    |> then(fn options -> Map.put_new(options, :prepend_line_number, "-n" in flags) end)
  end

  defp readlines(filename) do
    io = File.open!(filename, [:read])

    try do
      IO.stream(io, :line) |> Enum.to_list()
    after
      File.close(io)
    end
  end

  defp do_content_search(content, pattern, options) do
    content
    |> Stream.with_index()
    |> Enum.reduce([], fn {line, index}, acc ->
      if match_pattern?(line, pattern, options) do
        if options.prepend_line_number, do: ["#{index + 1}:#{line}" | acc], else: [line | acc]
      else
        acc
      end
    end)
    |> Enum.reverse()
  end

  defp match_pattern?(line, pattern, options) do
    result =
      cond do
        options.case_insensitive and options.match_entire_line ->
          downcased_line = String.downcase(line)
          String.trim(downcased_line) == String.downcase(pattern)

        options.case_insensitive ->
          downcased_line = String.downcase(line)
          downcased_pattern = String.downcase(pattern)
          String.contains?(downcased_line, downcased_pattern)

        options.match_entire_line ->
          String.trim(line) == pattern

        true ->
          String.contains?(line, pattern)
      end

    if options.invert_search, do: !result, else: result
  end
end
