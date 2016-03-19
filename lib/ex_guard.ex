defmodule ExGuard do
  @moduledoc """
  This module is the main process which listens to file changes,
  triggers commands and notifications
  """

  use GenServer
  alias ExGuard.Guard
  alias ExGuard.Config

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
    |> Config.match_guards
    |> execute_guards
    {:noreply, state}
  end

  @doc false
  def execute_guards(guards) do
    guards
    |> Enum.map(&Guard.execute(&1))
    |> Enum.each(&Guard.notify(&1))
  end
end
