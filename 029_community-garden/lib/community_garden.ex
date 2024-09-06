# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(_opts \\ []), do: Agent.start(fn -> %{last_plot_id: 0, plots: []} end)

  def list_registrations(pid), do: Agent.get(pid, & &1.plots)

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn %{last_plot_id: last_plot_id, plots: plots} ->
      new_plot = %Plot{plot_id: last_plot_id + 1, registered_to: register_to}
      updated_state = %{last_plot_id: new_plot.plot_id, plots: plots ++ [new_plot]}
      {new_plot, updated_state}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn %{plots: plots} = state ->
      elem = Enum.find(plots, &(&1.plot_id == plot_id))
      if elem, do: %{state | plots: List.delete(plots, elem)}, else: state
    end)
  end

  def get_registration(pid, plot_id) do
    list_registrations(pid)
    |> Enum.find(&(&1.plot_id == plot_id)) || {:not_found, "plot is unregistered"}
  end
end
