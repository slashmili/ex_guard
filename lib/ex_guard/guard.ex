defmodule ExGuard.Guard do
  @moduledoc """
  Users use functions in this module to build config files.

      guard("test")
      |> command("mix text --color")
      |> watch(~r{\\.(ex|exs)$})
      |> notification(:auto)
  """

  defstruct  title: "", cmd: "", watch: [], notification: :auto, ignore: [], options: []

  @doc """
  Creates ExGuard config.

      guard("test")

  If you want to run the command on start set `:run_on_start` option

      guard("test", run_on_start: true)
  """
  def guard(title, opts \\ []) do
    guard_struct = %ExGuard.Guard{title: title, options: opts}
    ExGuard.Config.put_guard(title, guard_struct)
  end

  @doc """
  Sets command for given guard config.

      guard("test")
      |> command("mix text --color")
  """
  def command(guard_struct, cmd) do
    guard_struct = %ExGuard.Guard{guard_struct | cmd: cmd}
    ExGuard.Config.put_guard(guard_struct.title, guard_struct)
  end

  @doc ~S"""
  Sets watch pattern for given guard config.

  To watch all Elixir and Erlang files set:
      guard("Elixir/Erlang files")
      |> watch(~r{\\.(erl|ex|exs|eex|xrl|yrl)\\z}i)

  To only execute the command for specific files use:
      guard("execute specific tests")
      |> watch({~r{lib/(?<dir>.+)/(?<file>.+).ex$}, fn(m) -> "test/#{m["dir"]}/#{m["file"]}_test.exs" end})
  """
  def watch(guard_struct, watch) do
    cur_watch = guard_struct.watch ++ [watch]
    guard_struct = %ExGuard.Guard{guard_struct | watch: cur_watch}
    ExGuard.Config.put_guard(guard_struct.title, guard_struct)
  end

  @doc """
  It can be used to exclude files and directories from the set of files being watched.

      guard("text files")
      |> ignore(~r/\\.txt$/)
  """
  def ignore(guard_struct, ignore_rule) do
    cur_ignore_rule = guard_struct.ignore ++ [ignore_rule]
    guard_struct = %ExGuard.Guard{guard_struct | ignore: cur_ignore_rule}
    ExGuard.Config.put_guard(guard_struct.title, guard_struct)
  end

  @doc """
  Sets notification for given guard config.
  By default notification is on.

      guard("test")
      |> notification(:auto)

  To turn off the notification set it to `:off`
      guard("not notification")
      |> notification(:off)
  """
 def notification(guard_struct, :auto) do
    guard_struct = %ExGuard.Guard{guard_struct | notification: :auto}
    ExGuard.Config.put_guard(guard_struct.title, guard_struct)
  end
  def notification(guard_struct, :off) do
    guard_struct = %ExGuard.Guard{guard_struct | notification: :off}
    ExGuard.Config.put_guard(guard_struct.title, guard_struct)
  end


  @doc """
  Executes the command for a guard config.

  If files is a list, append them to guard.cmd and executes it.
  """
  def execute({guard, files}) do
    arg = Enum.join(files, " ")
    cmd = String.strip("#{guard.cmd} #{arg}")
    IO.puts "ex_guard is executing #{cmd}"
    case Mix.Shell.IO.cmd(cmd) do
      0 -> {:ok, 0, "", guard}
      status -> {:error, status , "", guard}
    end
  end
  def execute(guard) do
    execute({guard, []})
  end

  @doc """
  notifies the result
  """
  def notify({_, _, _, %ExGuard.Guard{notification: :off}}) do
    :off
  end
  def notify({:ok, _status_code, _message, %ExGuard.Guard{notification: :auto} = guard}) do
    ExGuard.Notifier.notify(title: guard.title, message: "successfully executed", status: :ok)
  end
  def notify({:error, _status_code, _message, %ExGuard.Guard{notification: :auto} = guard}) do
    ExGuard.Notifier.notify(title: guard.title, message: "failed to execute", status: :error)
  end
end
