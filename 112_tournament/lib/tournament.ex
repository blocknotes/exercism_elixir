defmodule Tournament do
  @header "Team                           | MP |  W |  D |  L |  P"

  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally([]), do: @header

  def tally(input) do
    [@header | do_tally(input)]
    |> Enum.join("\n")
  end

  defp do_tally(input) do
    input
    |> prepare_stats()
    |> Enum.sort(fn {squad1, stats1}, {squad2, stats2} ->
      if stats1.p == stats2.p, do: squad1 < squad2, else: stats1.p > stats2.p
    end)
    |> Enum.map(&format_stats/1)
  end

  defp prepare_stats(input) do
    Enum.reduce(input, %{}, fn line, acc ->
      case String.split(line, ";") do
        [squad1, squad2, result] when result in ["win", "loss", "draw"] ->
          update_match_stats(acc, squad1, squad2, result)

        _ ->
          acc
      end
    end)
  end

  defp update_match_stats(stats, squad1, squad2, result) do
    stats = Map.put_new(stats, squad1, initial_state())
    stats = Map.put_new(stats, squad2, initial_state())
    %{^squad1 => stats1, ^squad2 => stats2} = stats

    case result do
      "win" ->
        stats1 = %{stats1 | mp: stats1.mp + 1, w: stats1.w + 1, p: stats1.p + 3}
        stats2 = %{stats2 | mp: stats2.mp + 1, l: stats2.l + 1}
        %{%{stats | squad1 => stats1} | squad2 => stats2}

      "loss" ->
        stats1 = %{stats1 | mp: stats1.mp + 1, l: stats1.l + 1}
        stats2 = %{stats2 | mp: stats2.mp + 1, w: stats2.w + 1, p: stats2.p + 3}
        %{%{stats | squad1 => stats1} | squad2 => stats2}

      "draw" ->
        stats1 = %{stats1 | mp: stats1.mp + 1, d: stats1.d + 1, p: stats1.p + 1}
        stats2 = %{stats2 | mp: stats2.mp + 1, d: stats2.d + 1, p: stats2.p + 1}
        %{%{stats | squad1 => stats1} | squad2 => stats2}
    end
  end

  defp format_stats({squad, stats}) do
    "~-30.. s |~3.. B |~3.. B |~3.. B |~3.. B |~3.. B"
    |> :io_lib.format([squad |> to_charlist(), stats.mp, stats.w, stats.d, stats.l, stats.p])
    |> to_string()
  end

  defp initial_state, do: %{mp: 0, w: 0, d: 0, l: 0, p: 0}
end
