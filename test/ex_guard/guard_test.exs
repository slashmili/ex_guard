defmodule ExGuard.GuardTest do
  use ExUnit.Case
  use ExGuard.Config

  setup do
    {:ok, _pid} = ExGuard.Config.start_link
    :ok
  end

  test "execute a guard successfully" do
    guard_struct = %ExGuard.Guard{title: "foobar", cmd: "test -z ''", watch: [~r/test\/*.exs$/]}
    assert execute(guard_struct) == {:ok, 0, "", guard_struct}
  end

  test "execute a guard unsuccessfully" do
    guard_struct = %ExGuard.Guard{title: "foobar", cmd: "test -z 'boo'", watch: [~r/test\/*.exs$/]}
    assert execute(guard_struct) == {:error, 1, "", guard_struct}
  end

  test "try to notify with notification :off" do
    assert notify({:ok, 0, "", %ExGuard.Guard{}}) == :off
    assert notify({:error, 1, "", %ExGuard.Guard{}}) == :off
  end

  test "try to notify with notification :auto and successful status" do
    assert notify({:ok, 0, "", %ExGuard.Guard{title: "inside test", notification: :auto}}) == :ok
  end

  test "try to notify with notification :auto and failed status" do
    assert notify({:error, 1, "", %ExGuard.Guard{title: "inside test", notification: :auto}}) == :ok
  end
end
