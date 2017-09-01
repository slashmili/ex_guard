defmodule ExGuard do
  @moduledoc """
  This module is the main process which listens to file changes,
  triggers commands and notifications
  """

  defstruct changed_files: []

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
    :erlang.send_after(2000, self(), :handle_file_changes)
    :ok = :fs.subscribe
    {:ok, %ExGuard{}}
  end

  @doc """
  Executes on file changes
  """
  def handle_info({_pid, {:fs, :file_event}, {path, event}}, state) do
    matched? =  path
                |> to_string
                |> Config.match_guards
    changed_files = if matched? == [] do
      state.changed_files
    else
      Enum.uniq(state.changed_files ++ [to_string(path)])
    end
    {:noreply, %{state| changed_files: changed_files}}
  end

  @doc false
  def handle_info(:handle_file_changes, state) do
    case state.changed_files do
      [] -> :noop
      changed_files ->
        changed_files
        |> Enum.map(&Config.match_guards/1)
        |> List.flatten
        |> Enum.uniq
        |> execute_guards
    end


    :erlang.send_after(2000, self(), :handle_file_changes)
    {:noreply, %{state | changed_files: []}}
  end

  @doc false
  def execute_guards(guards) do
    guards
    |> Enum.map(&Guard.execute(&1))
    |> Enum.each(&Guard.notify(&1))
  end
end
