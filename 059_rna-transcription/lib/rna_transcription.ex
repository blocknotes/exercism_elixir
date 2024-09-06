defmodule RnaTranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

    iex> RnaTranscription.to_rna(~c"ACTG")
    ~c"UGAC"
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    Enum.reduce(dna, [], fn i, acc -> acc ++ [mapping()[i]] end)
  end

  defp mapping do
    %{
      ?G => ?C,
      ?C => ?G,
      ?T => ?A,
      ?A => ?U
    }
  end
end
