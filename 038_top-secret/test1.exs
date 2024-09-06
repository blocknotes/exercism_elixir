defmodule M1 do
  def do_traverse(ast, acc \\ [])

  def do_traverse({op, _, args}, acc) do
    case args do
      [{name, _, _}, _] when op == :def or op == :defp -> do_traverse(args, acc ++ [name])
      _ -> do_traverse(args, acc)
    end
  end

  def do_traverse({_, args}, acc), do: do_traverse(args, acc)

  def do_traverse(ast, acc) when is_list(ast),
    do: Enum.reduce(ast, acc, fn node, acc -> do_traverse(node, acc) end)

  def do_traverse(_, acc), do: acc
end

code =
  "defmodule Notebook do\n  def note(notebook, text) do\n    add_to_notebook(notebook, text, append: true)\n  end\nend\n"

{:ok, ast} = Code.string_to_quoted(code)

ret = M1.do_traverse(ast)
IO.puts(inspect(ret))
