defmodule TakeANumberDeluxe do
  use GenServer

  # Client API

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(init_arg) do
    result =
      TakeANumberDeluxe.State.new(
        init_arg[:min_number],
        init_arg[:max_number],
        init_arg[:auto_shutdown_timeout] || :infinity
      )

    case result do
      {:ok, state} -> GenServer.start_link(__MODULE__, state)
      error -> error
    end
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine), do: GenServer.call(machine, :report_state)

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine), do: GenServer.call(machine, :queue_new_number)

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil),
    do: GenServer.call(machine, {:serve_next_queued_number, priority_number})

  @spec reset_state(pid()) :: :ok
  def reset_state(machine), do: GenServer.call(machine, :reset_state)

  # Server callbacks

  @impl GenServer
  def init(state), do: append_timeout(state, {:ok, state})

  @impl GenServer
  def handle_call(:report_state, _from, state), do: append_timeout(state, {:reply, state, state})

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    result = TakeANumberDeluxe.State.queue_new_number(state)

    case result do
      {:ok, number, new_state} -> append_timeout(new_state, {:reply, {:ok, number}, new_state})
      error -> append_timeout(state, {:reply, error, state})
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    result = TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number)

    case result do
      {:ok, number, new_state} -> append_timeout(new_state, {:reply, {:ok, number}, new_state})
      error -> append_timeout(state, {:reply, error, state})
    end
  end

  @impl GenServer
  def handle_call(:reset_state, _from, state) do
    {:ok, new_state} =
      TakeANumberDeluxe.State.new(
        state.min_number,
        state.max_number,
        state.auto_shutdown_timeout
      )

    append_timeout(new_state, {:reply, :ok, new_state})
  end

  @impl GenServer
  def handle_cast(:timeout, state), do: {:noreply, state}

  @impl GenServer
  def handle_info(:timeout, state), do: {:stop, :normal, state}

  @impl GenServer
  def handle_info(_, state), do: {:noreply, state, state.auto_shutdown_timeout}

  defp append_timeout(%{auto_shutdown_timeout: timeout}, response) when timeout != :infinity,
    do: Tuple.append(response, timeout)

  defp append_timeout(_, response), do: response
end
