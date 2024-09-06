defmodule LogParser do
  def valid_line?(line), do: line =~ ~r/\A\[DEBUG\]|\[INFO\]|\[WARNING\]|\[ERROR\]/

  def split_line(line), do: String.split(line, ~r/<[~*=-]*>/)

  def remove_artifacts(line), do: String.replace(line, ~r/end-of-line\d+/i, "")

  def tag_with_user_name(line) do
    with [_, user_name] <- Regex.run(~r/User\s+([^\s]+)/, line),
         do: "[USER] #{user_name} #{line}",
         else: (_ -> line)
  end
end
