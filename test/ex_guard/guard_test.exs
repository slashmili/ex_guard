defmodule ExGuard.GuardTest do
  use ExUnit.Case
  use ExGuard.Config

  setup do
    {:ok, _pid} = ExGuard.Config.start_link
    :ok
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
