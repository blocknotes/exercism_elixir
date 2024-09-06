defmodule TakeANumber do
  def start, do: spawn(&init/0)

  defp init, do: receive_message(0)

  defp receive_message(counter) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, counter)
        receive_message(counter)

      {:take_a_number, sender_pid} ->
        counter = counter + 1
        send(sender_pid, counter)
        receive_message(counter)

      :stop ->
        nil

      _ ->
        receive_message(counter)
    end
  end
end
