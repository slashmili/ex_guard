defmodule ExGuard.Guard do
  defstruct  title: "", cmd: "", watch: []

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
end
