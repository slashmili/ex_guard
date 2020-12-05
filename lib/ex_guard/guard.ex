defmodule ExGuard.Guard do
  @moduledoc """
  Users use functions in this module to build config files.

      guard("test")
      |> command("mix text --color")
      |> watch(~r{\\.(ex|exs)$})
      |> notification(:auto)
  """

  alias ExGuard.Notifier
  alias ExGuard.Config
  defstruct title: "", cmd: "", watch: [], notification: :auto, ignore: [], options: []

  @doc """
  Creates ExGuard config.

      guard("test")

  Options:

    * `:run_on_start`, set this option If you want to run the command when `mix guard` has been executed
    * `:umbrella_app`, set this option If you are running guard on the main directory of an umbrella project and using `watch` command to match changed filed with test

      guard("test", run_on_start: true, umbrella_app: true)
  """
  def guard(title, opts \\ []) do
    guard_struct = %ExGuard.Guard{title: title, options: opts}
    Config.put_guard(title, guard_struct)
  end

  @doc """
  Sets command for given guard config.

      guard("test")
      |> command("mix text --color")
  """
  def command(guard_struct, cmd) do
    guard_struct = %ExGuard.Guard{guard_struct | cmd: cmd}
    Config.put_guard(guard_struct.title, guard_struct)
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
  def watch(guard_struct, pattern) do
    cur_watch = guard_struct.watch ++ [pattern]
    guard_struct = %ExGuard.Guard{guard_struct | watch: cur_watch}
    Config.put_guard(guard_struct.title, guard_struct)
  end

  @doc """
  It can be used to exclude files and directories from the set of files being watched.

      guard("text files")
      |> ignore(~r/\\.txt$/)
  """
  def ignore(guard_struct, ignore_rule) do
    cur_ignore_rule = guard_struct.ignore ++ [ignore_rule]
    guard_struct = %ExGuard.Guard{guard_struct | ignore: cur_ignore_rule}
    Config.put_guard(guard_struct.title, guard_struct)
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
    Config.put_guard(guard_struct.title, guard_struct)
  end

  def notification(guard_struct, :off) do
    guard_struct = %ExGuard.Guard{guard_struct | notification: :off}
    Config.put_guard(guard_struct.title, guard_struct)
  end

  @doc """
  Executes the command for a guard config.

  If files is a list, append them to guard.cmd and executes it.
  """
  def execute({guard_config, files}) do
    umbrella_app? = Keyword.get(guard_config.options, :umbrella_app, false)

    files =
      if umbrella_app? do
        Enum.map(files, fn path ->
          String.replace(path, ~r{^apps/[a-zA-z_]+/}, "")
        end)
      else
        files
      end

    arg = Enum.join(files, " ")
    cmd = String.trim("#{guard_config.cmd} #{arg}")
    Mix.Shell.IO.info("ex_guard is executing #{guard_config.title}")

    case Mix.Shell.IO.cmd(cmd) do
      0 -> {:ok, 0, "", guard_config}
      status -> {:error, status, "", guard_config}
    end
  end

  def execute(guard_config) do
    execute({guard_config, []})
  end

  @doc """
  notifies the result
  """
  def notify({_, _, _, %ExGuard.Guard{notification: :off}}) do
    :off
  end

  def notify({:ok, _status_code, _message, %ExGuard.Guard{notification: :auto} = guard_config}) do
    Notifier.notify(
      title: guard_config.title,
      message: "successfully executed",
      status: :ok
    )
  end

  def notify({:error, _status_code, _message, %ExGuard.Guard{notification: :auto} = guard_config}) do
    Notifier.notify(
      title: guard_config.title,
      message: "failed to execute",
      status: :error
    )
  end
end
