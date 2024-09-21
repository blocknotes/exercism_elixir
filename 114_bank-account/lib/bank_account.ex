defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  use Agent

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    with {:ok, pid} <- Agent.start_link(fn -> {0, :open} end), do: pid
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    Agent.update(account, fn {balance, _state} -> {balance, :closed} end)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) do
    Agent.get(account, fn {balance, state} ->
      if state == :closed, do: {:error, :account_closed}, else: balance
    end)
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(_account, amount) when amount < 0, do: {:error, :amount_must_be_positive}

  def deposit(account, amount) do
    Agent.get_and_update(account, fn {balance, state} = current_state ->
      cond do
        state == :closed -> {{:error, :account_closed}, current_state}
        true -> {:ok, {balance + amount, state}}
      end
    end)
  end

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(_account, amount) when amount < 0, do: {:error, :amount_must_be_positive}

  def withdraw(account, amount) do
    Agent.get_and_update(account, fn {balance, state} = current_state ->
      cond do
        state == :closed -> {{:error, :account_closed}, current_state}
        amount > balance -> {{:error, :not_enough_balance}, current_state}
        true -> {:ok, {balance - amount, state}}
      end
    end)
  end
end
