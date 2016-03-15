defmodule ExGuard do
  def start_link do
    :ok  = Application.start :fs, :permanent
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    :ok = :fs.subscribe
    {:ok, Map.new}
  end

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, state) do
    path
    |> to_string
    |> ExGuard.Config.match_guards
    |> Enum.each(&ExGuard.Guard.execute(&1))
    {:noreply, state}
  end
end
