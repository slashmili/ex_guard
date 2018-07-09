defmodule ExGuard.GuardTest do
  use ExUnit.Case, async: false
  use ExGuard.Config
  import ExUnit.CaptureIO

  setup do
    {:ok, _pid} = ExGuard.Config.start_link()
    :ok
  end

  test "execute a guard successfully" do
    guard_struct = %ExGuard.Guard{title: "foobar", cmd: "test -z ''", watch: [~r/test\/*.exs$/]}

    capture_io(fn ->
      assert execute({guard_struct, []}) == {:ok, 0, "", guard_struct}
    end)
  end

  test "execute a guard unsuccessfully" do
    guard_struct = %ExGuard.Guard{
      title: "foobar",
      cmd: "test -z 'boo'",
      watch: [~r/test\/*.exs$/]
    }

    capture_io(fn ->
      assert execute({guard_struct, []}) == {:error, 1, "", guard_struct}
    end)
  end

  test "try to notify with notification :auto" do
    assert notify({:ok, 0, "", %ExGuard.Guard{title: "inside test", notification: :auto}}) == :ok
  end

  test "try to notify with notification :off and successful status" do
    assert notify({:ok, 0, "", %ExGuard.Guard{notification: :off}}) == :off
    assert notify({:error, 0, "", %ExGuard.Guard{notification: :off}}) == :off
  end

  test "try to notify with notification :auto and failed status" do
    assert notify({:error, 1, "", %ExGuard.Guard{title: "inside test", notification: :auto}}) ==
             :ok
  end

  test "execute a guard with specific file" do
    guard_struct = %ExGuard.Guard{
      title: "foobar",
      cmd: "test -f ",
      watch: [{~r/test\/*.exs$/, fn m -> m end}]
    }

    capture_io(fn ->
      assert execute({guard_struct, ["boo"]}) == {:error, 1, "", guard_struct}
    end)
  end
end
