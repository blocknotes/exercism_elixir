defmodule TopSecret do
  def to_ast(string) do
    with {:ok, ast} = Code.string_to_quoted(string), do: ast
  end

  def decode_secret_message_part(ast, acc) do
    case ast do
      {:def, _, [{:when, _, [{name, _, args}, _]}, _]} ->
        {ast, [do_format_name(name, args) | acc]}

      {:defp, _, [{:when, _, [{name, _, args}, _]}, _]} ->
        {ast, [do_format_name(name, args) | acc]}

      {:def, _, [{name, _, args}, _]} ->
        {ast, [do_format_name(name, args) | acc]}

      {:defp, _, [{name, _, args}, _]} ->
        {ast, [do_format_name(name, args) | acc]}

      _ ->
        {ast, acc}
    end
  end

  def decode_secret_message(string) do
    string
    |> to_ast()
    |> do_traverse()
    |> Enum.join()
  end

  defp do_format_name(name, args) when is_list(args),
    do: String.slice(to_string(name), 0, length(args))

  defp do_format_name(_, _), do: ""

  defp do_traverse(ast, acc \\ [])

  defp do_traverse({_, _, args} = ast, acc) do
    with {_, result} <- decode_secret_message_part(ast, []), do: do_traverse(args, acc ++ result)
  end

  defp do_traverse({_, args}, acc), do: do_traverse(args, acc)

  defp do_traverse(ast, acc) when is_list(ast), do: Enum.reduce(ast, acc, &do_traverse/2)

  defp do_traverse(_, acc), do: acc
end
