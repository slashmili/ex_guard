defmodule ExGuard.Guard do
  defstruct  title: "", cmd: "", watch: [], notification: :auto

  def guard(title) do
    guard_struct = %ExGuard.Guard{title: title}
    ExGuard.Config.put_guard(title, guard_struct)
  end

  def command(guard_struct, cmd) do
    guard_struct = %ExGuard.Guard{guard_struct | cmd: cmd}
    ExGuard.Config.put_guard(guard_struct.title, guard_struct)
  end

  def watch(guard_struct, watch) do
    cur_watch = guard_struct.watch ++ [watch]
    guard_struct = %ExGuard.Guard{guard_struct | watch: cur_watch}
    ExGuard.Config.put_guard(guard_struct.title, guard_struct)
  end

  def notification(guard_struct, :auto) do
    guard_struct = %ExGuard.Guard{guard_struct | notification: :auto}
    ExGuard.Config.put_guard(guard_struct.title, guard_struct)
  end
  def notification(guard_struct, :off) do
    guard_struct = %ExGuard.Guard{guard_struct | notification: :off}
    ExGuard.Config.put_guard(guard_struct.title, guard_struct)
  end


  def execute({guard, files}) do
    arg = Enum.join(files, " ")
    cmd = String.strip("#{guard.cmd} #{arg}")
    IO.puts "ex_guard is executing #{cmd}"
    case Mix.Shell.IO.cmd(cmd) do
      0 -> {:ok, 0, "", guard}
      status -> {:error, status , "", guard}
    end
  end

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
