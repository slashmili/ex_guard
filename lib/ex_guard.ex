defmodule ExGuard do
  @moduledoc """
  This module is the main process which listens to file changes,
  triggers commands and notifications
  """

  use GenServer

  @doc false
  def start_link do
    :ok  = Application.start :fs, :permanent
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc false
  def init(_) do
    :ok = :fs.subscribe
    {:ok, Map.new}
  end

  @doc """
  Executes on file changes
  """
  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, state) do
    path
    |> to_string
    |> ExGuard.Config.match_guards
    |> Enum.map(&ExGuard.Guard.execute(&1))
    |> Enum.each(&ExGuard.Guard.notify(&1))
    {:noreply, state}
  end
end
